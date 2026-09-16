"""Backend AI lesson generation — must NEVER run inside the iOS app.

MockAILessonGenerator produces structured lesson drafts from skill + levels
without calling any external API. Live AI providers belong here when AI_API_KEY
is configured; until then use the mock.

Privacy: only anonymous learner_id is accepted. Names, DOB, and contact data
are rejected.
"""

from __future__ import annotations

import re
import uuid
from abc import ABC, abstractmethod
from dataclasses import dataclass, field
from typing import Any

from src.errors import PrivacyViolationError
from src.providers.standards import Skill


FORBIDDEN_PII_KEYS = frozenset(
    {
        "name",
        "child_name",
        "childname",
        "first_name",
        "lastname",
        "last_name",
        "full_name",
        "dob",
        "date_of_birth",
        "birthday",
        "birthdate",
        "email",
        "phone",
        "contact",
        "address",
        "parent_name",
        "parent_email",
        "parent_phone",
    }
)


@dataclass
class LessonGenerationRequest:
    """Anonymous generation request — no child PII."""

    age_range: str
    grade: str
    reading_level: str
    math_level: str
    learning_objective: str
    standard_skill_id: str
    prerequisites: list[str] = field(default_factory=list)
    mastered_skills: list[str] = field(default_factory=list)
    practice_skills: list[str] = field(default_factory=list)
    interests: list[str] = field(default_factory=list)
    activity_type: str = "story_practice"
    learning_outcome: str = ""
    learner_id: str | None = None  # anonymous UUID only
    subject: str = "Reading"
    skill_statement: str = ""

    def validate_privacy(self) -> None:
        if self.learner_id is not None:
            lid = self.learner_id.strip()
            if not lid:
                raise PrivacyViolationError("learner_id must be empty or a non-empty anonymous id")
            # Reject obvious names / emails embedded in the id string
            if "@" in lid or re.search(r"\s", lid):
                raise PrivacyViolationError("learner_id must be anonymous (no spaces or emails)")
            if not re.fullmatch(r"[A-Za-z0-9_\-]{8,64}", lid):
                raise PrivacyViolationError(
                    "learner_id must be an anonymous token (UUID-like), never a real name"
                )

        # Reject if any interest looks like PII key stuffing (defensive)
        for interest in self.interests:
            if interest.lower().replace(" ", "_") in FORBIDDEN_PII_KEYS:
                raise PrivacyViolationError(f"Forbidden PII field used as interest: {interest}")


class AILessonGenerator(ABC):
    @property
    @abstractmethod
    def provider_name(self) -> str: ...

    @property
    @abstractmethod
    def runs_on_backend_only(self) -> bool: ...

    @abstractmethod
    def generate(self, request: LessonGenerationRequest) -> dict[str, Any]:
        """Return a structured lesson draft dict."""


def _theme_from_interests(interests: list[str]) -> str:
    if not interests:
        return "Ocean"
    preferred = ["Ocean", "Space", "Dinosaurs", "Horses", "Sharks"]
    for p in preferred:
        if any(p.lower() in i.lower() or i.lower() in p.lower() for i in interests):
            return p
    return interests[0].title()


def _reading_band(level: str) -> str:
    lower = level.lower()
    if "beginner" in lower:
        return "Beginner"
    if "early" in lower:
        return "Early Reader"
    if "growing" in lower:
        return "Growing Reader"
    if "confident" in lower:
        return "Confident Reader"
    return "Early Reader"


def _math_band(level: str) -> str:
    lower = level.lower()
    if "emerg" in lower:
        return "Emerging"
    if "develop" in lower:
        return "Developing"
    if "secur" in lower:
        return "Secure"
    if "advanc" in lower:
        return "Advancing"
    return "Developing"


# ---------------------------------------------------------------------------
# Grossly different reading banks per band (not number-swapped templates)
# ---------------------------------------------------------------------------

READING_CONTENT: dict[str, dict[str, Any]] = {
    "Beginner": {
        "title_suffix": "Sounds and Pictures",
        "instructions": "Look. Listen. Tap the match.",
        "story_openings": {
            "Ocean": "Willa the Whale smiles. She sees a big blue wave.",
            "Space": "Nova the Star blinks. She sees a bright moon.",
            "Dinosaurs": "Dottie the Dino stomps. She finds a round egg.",
            "Horses": "Sunny the Horse trots. She sees soft green grass.",
            "Sharks": "Willa swims. A friendly shark glides by.",
        },
        "passages": {
            "Ocean": (
                "Willa sees a shell. The shell is pink. "
                "Willa taps the shell. Splash!"
            ),
            "Space": (
                "Nova sees a star. The star is gold. "
                "Nova waves at the star. Twinkle!"
            ),
            "Dinosaurs": (
                "Dottie sees a leaf. The leaf is green. "
                "Dottie munches the leaf. Crunch!"
            ),
            "Horses": (
                "Sunny sees an apple. The apple is red. "
                "Sunny nibbles the apple. Yum!"
            ),
            "Sharks": (
                "The shark sees a fish. The fish is small. "
                "The shark swims past. Whoosh!"
            ),
        },
        "vocab_style": "one-syllable concrete nouns",
        "question_kinds": ["identify", "who_what"],
        "max_choices": 2,
        "sample_questions": lambda theme, passage: [
            {
                "id": str(uuid.uuid4()),
                "subject": "reading",
                "type": "multipleChoice",
                "prompt": f"What does the friend see first?",
                "choices": _beginner_choices(theme),
                "correct_answers": [_beginner_correct(theme)],
                "explanation": "The story names that object first.",
                "hints": ["Look at the first sentence."],
            },
            {
                "id": str(uuid.uuid4()),
                "subject": "reading",
                "type": "multipleChoice",
                "prompt": "What sound word is in the story?",
                "choices": _beginner_sound_choices(theme),
                "correct_answers": [_beginner_sound(theme)],
                "explanation": "That sound ends the short story.",
                "hints": ["Check the last sentence."],
            },
        ],
    },
    "Early Reader": {
        "title_suffix": "Short Word Adventure",
        "instructions": "Read each short sentence. Then answer who and what.",
        "story_openings": {
            "Ocean": "Willa the Whale paddles near a sunny reef. She wants to find a smooth stone.",
            "Space": "Nova the Star floats beside a quiet moon rock. She wants to map a safe path.",
            "Dinosaurs": "Dottie the Dino walks to a cool watering hole. She wants to share a snack.",
            "Horses": "Sunny the Horse trots along a dusty trail. She wants to reach the apple tree.",
            "Sharks": "A gentle reef shark glides under bright kelp. Willa watches from nearby.",
        },
        "passages": {
            "Ocean": (
                "Willa looks under a flat rock. She finds three smooth stones. "
                "A crab scurries away. Willa keeps one stone for her collection. "
                "Then she swims back to the reef."
            ),
            "Space": (
                "Nova checks her glow map. She marks two safe landing spots. "
                "A small robot beeps beside her. Nova shares the map with the crew. "
                "They practice the path one more time."
            ),
            "Dinosaurs": (
                "Dottie finds four fern leaves by the water. A friend arrives hungry. "
                "Dottie gives two leaves away. They sit and chew together. "
                "The watering hole stays calm and cool."
            ),
            "Horses": (
                "Sunny sees ripe apples on a low branch. She takes two careful steps. "
                "A bird sings from the fence. Sunny reaches an apple and munches happily. "
                "Then she trots home along the trail."
            ),
            "Sharks": (
                "The reef shark circles a sandy patch. It finds five tiny fish. "
                "The fish dart into a coral cave. The shark swims on without chasing. "
                "Willa cheers for the peaceful swim."
            ),
        },
        "vocab_style": "high-frequency + simple decodable words",
        "question_kinds": ["key_detail", "sequence_light"],
        "max_choices": 3,
        "sample_questions": lambda theme, passage: [
            {
                "id": str(uuid.uuid4()),
                "subject": "reading",
                "type": "multipleChoice",
                "prompt": "Where does the story mostly take place?",
                "choices": _early_place_choices(theme),
                "correct_answers": [_early_place(theme)],
                "explanation": "The setting is named in the opening and passage.",
                "hints": ["Reread the first two sentences."],
            },
            {
                "id": str(uuid.uuid4()),
                "subject": "reading",
                "type": "multipleChoice",
                "prompt": "What happens near the end?",
                "choices": _early_ending_choices(theme),
                "correct_answers": [_early_ending(theme)],
                "explanation": "The last sentence tells the ending action.",
                "hints": ["Check the final sentence."],
            },
            {
                "id": str(uuid.uuid4()),
                "subject": "reading",
                "type": "multipleChoice",
                "prompt": "Which detail is in the passage?",
                "choices": _early_detail_choices(theme),
                "correct_answers": [_early_detail(theme)],
                "explanation": "That detail is stated in the text.",
                "hints": ["Scan for numbers and objects."],
            },
        ],
    },
    "Growing Reader": {
        "title_suffix": "Main Idea Mission",
        "instructions": (
            "Read the passage carefully. Look for the main idea and the details that support it. "
            "Use clues from the text when you answer."
        ),
        "story_openings": {
            "Ocean": (
                "Mission lights flickered across the reef station as Willa the Whale "
                "reviewed today's research plan: study how coral shelters small fish."
            ),
            "Space": (
                "Nova checks a list of water pouches and tools. "
                "She wants to get them to friends on the Moon."
            ),
            "Dinosaurs": (
                "Morning mist hung over the valley while Dottie the Dino gathered "
                "tools for a fossil walk with young explorers."
            ),
            "Horses": (
                "Sunny the Horse waited at the barn gate, ready to guide riders "
                "along a trail that taught careful observation of animal tracks."
            ),
            "Sharks": (
                "Willa prepared notes at the kelp observation post on how reef sharks "
                "help keep the ocean neighborhood balanced."
            ),
        },
        "passages": {
            "Ocean": (
                "Coral reefs are busy homes under the sea. Tiny fish dart between coral branches "
                "when larger animals swim near. Willa explains that the coral's nooks give shelter "
                "and a place to find food. Scientists watch which fish return after a storm. "
                "If the coral stays healthy, more fish families can thrive. Willa records three "
                "sheltering spots on her waterproof chart before the tide shifts."
            ),
            "Space": (
                "Nova's crew must deliver four water pouches and two antenna tools before night "
                "cycle begins. The Moon has no air, so every checklist item matters. Nova reads "
                "the supply list aloud while a robot confirms each count. Craters make landing "
                "tricky, so the team practices a slow approach. When the final pouch is sealed, "
                "Nova marks the main goal: keep the outpost crew safely supplied."
            ),
            "Dinosaurs": (
                "Dottie shows the explorers a cracked eggshell half-buried in soft clay. "
                "She explains that fossils are clues about animals that lived long ago. "
                "The group sketches the shell's ridges and measures its width with a string. "
                "Nearby footprints suggest the nest was visited more than once. Dottie's main "
                "lesson is that careful looking turns scattered clues into a clearer story."
            ),
            "Horses": (
                "Along the trail, Sunny slows near a muddy patch dotted with hoof prints. "
                "Riders compare deep prints to lighter ones and guess which horse passed recently. "
                "Sunny demonstrates how calm observation prevents startling wildlife. A hawk "
                "circles above the pasture, and the group notes its path in a trail journal. "
                "The ride's purpose is learning to notice patterns, not racing to the finish."
            ),
            "Sharks": (
                "Reef sharks rarely hunt the fish children imagine from movies. Instead, they "
                "help remove weak or sick fish, which supports a healthier reef. Willa points to "
                "a shark gliding past without chasing the schools nearby. Divers count how many "
                "sharks visit each week and share the data with marine educators. The big idea: "
                "predators can be partners in keeping ocean homes in balance."
            ),
        },
        "vocab_style": "context-supported academic words (shelter, supply, fossil, pattern)",
        "question_kinds": ["main_idea", "key_detail", "cause_effect_light"],
        "max_choices": 3,
        "sample_questions": lambda theme, passage: [
            {
                "id": str(uuid.uuid4()),
                "subject": "reading",
                "type": "multipleChoice",
                "prompt": "What is the main idea of the passage?",
                "choices": _growing_main_choices(theme),
                "correct_answers": [_growing_main(theme)],
                "explanation": "The passage repeatedly supports that central idea.",
                "hints": ["Ask what the whole passage is mostly about."],
            },
            {
                "id": str(uuid.uuid4()),
                "subject": "reading",
                "type": "multipleChoice",
                "prompt": "Which detail best supports the main idea?",
                "choices": _growing_support_choices(theme),
                "correct_answers": [_growing_support(theme)],
                "explanation": "That detail directly backs the central message.",
                "hints": ["Find a sentence that proves the main idea."],
            },
            {
                "id": str(uuid.uuid4()),
                "subject": "reading",
                "type": "multipleChoice",
                "prompt": "According to the passage, why does the character take notes or observe carefully?",
                "choices": _growing_why_choices(theme),
                "correct_answers": [_growing_why(theme)],
                "explanation": "The text states the purpose of careful observation.",
                "hints": ["Look for because / so / purpose language."],
            },
        ],
    },
    "Confident Reader": {
        "title_suffix": "Evidence and Inference",
        "instructions": (
            "Read independently. Use evidence from the passage to explain inferences. "
            "Compare details before choosing an answer."
        ),
        "story_openings": {
            "Ocean": (
                "Storm season had thinned one section of the reef, and Willa the Whale "
                "needed volunteers who could compare old survey maps with today's dive notes."
            ),
            "Space": (
                "Nova the Star faced a timing puzzle: the antenna tools had to reach the "
                "far crater before the communication window closed for thirty hours."
            ),
            "Dinosaurs": (
                "Two fossil sites told conflicting stories, and Dottie the Dino asked the "
                "explorers to decide which clues were stronger—and why."
            ),
            "Horses": (
                "Sunny the Horse led a tracking lesson after a sudden rain that required "
                "riders to weigh competing explanations for a broken fence rail."
            ),
            "Sharks": (
                "Conflicting dive logs disagreed about shark visits after the storm, so "
                "Willa challenged the team to reconcile the evidence."
            ),
        },
        "passages": {
            "Ocean": (
                "Last year's map showed thick coral fingers along the north ledge. Today's "
                "divers report broken branches and fewer hiding places for juvenile fish. "
                "Willa notices that the south ledge still matches the older drawing. She "
                "hypothesizes that the storm surge struck hardest from the north. If the team "
                "plants nursery coral on the damaged ledge and monitors fish counts monthly, "
                "they can test whether shelter returns. A competing idea—that pollution alone "
                "caused the change—fits poorly, because water samples near both ledges test similar. "
                "Willa asks the crew to cite the map difference before proposing a fix."
            ),
            "Space": (
                "Nova reviews three failed delivery attempts. Each time, the rover left on schedule "
                "but arrived after the communication window. The crater path is longer than the "
                "training course by nearly a kilometer of jagged ridges. Nova infers the schedule "
                "underestimates travel time, not the crew's packing speed. Switching to an earlier "
                "departure would preserve the antenna install before blackout. A teammate suggests "
                "skipping tool checks; Nova rejects that because past missions show unchecked tools "
                "fail on the surface. Evidence from the logs supports adjusting the timeline, not "
                "lowering safety standards."
            ),
            "Dinosaurs": (
                "Site A contains crushed eggshells mixed with adult footprints facing outward, "
                "as if a caretaker left in a hurry. Site B shows intact nest circles but no adult "
                "tracks nearby. Explorers might infer Site A records a disturbed nest while Site B "
                "shows eggs left unattended. Dottie cautions that wind can erase tracks, so missing "
                "prints at Site B are weaker evidence than the outward tracks at Site A. Comparing "
                "both sites, the stronger claim is that Site A captures a moment of interruption. "
                "Any conclusion still needs more measurements of shell thickness and soil layers."
            ),
            "Horses": (
                "The fence rail is splintered outward, and deep hoof marks cluster on the pasture "
                "side. One rider claims a wild animal pushed in from the woods; another claims a "
                "startled horse kicked from inside. Sunny notes bark scrapes on the wooded side are "
                "absent, while the hoof cluster matches Sunny's own students who bolted yesterday. "
                "The stronger inference favors an inside kick during the rain scare. Still, Sunny "
                "asks for photos of the rail grain before the group finalizes the report, modeling "
                "how careful riders revise ideas when new evidence appears."
            ),
            "Sharks": (
                "Dive Log Blue lists six reef-shark visits in the week after the storm; Dive Log "
                "Green lists two. Both teams used the same observation window at dusk. Willa notices "
                "Green's camera faced the sand flat, while Blue filmed the drop-off where sharks "
                "usually patrol. The mismatch likely reflects camera aim, not a sudden shark "
                "disappearance. If next week's crews film both zones, counts should converge. "
                "Willa rejects the claim that sharks abandoned the reef entirely—the kelp fish "
                "counts remain stable, which would be unlikely if apex traffic vanished overnight."
            ),
        },
        "vocab_style": "evidence, hypothesize, infer, competing claim, reconcile",
        "question_kinds": ["inference", "compare_contrast", "evidence"],
        "max_choices": 4,
        "sample_questions": lambda theme, passage: [
            {
                "id": str(uuid.uuid4()),
                "subject": "reading",
                "type": "multipleChoice",
                "prompt": "What can you reasonably infer from the passage?",
                "choices": _confident_infer_choices(theme),
                "correct_answers": [_confident_infer(theme)],
                "explanation": "The inference is supported by specific textual evidence.",
                "hints": ["Combine two details rather than guessing."],
            },
            {
                "id": str(uuid.uuid4()),
                "subject": "reading",
                "type": "multipleChoice",
                "prompt": "Which evidence best supports the stronger claim in the passage?",
                "choices": _confident_evidence_choices(theme),
                "correct_answers": [_confident_evidence(theme)],
                "explanation": "That detail is cited as the stronger support.",
                "hints": ["Look for what the character treats as stronger evidence."],
            },
            {
                "id": str(uuid.uuid4()),
                "subject": "reading",
                "type": "multipleChoice",
                "prompt": "Why does the passage reject a competing explanation?",
                "choices": _confident_reject_choices(theme),
                "correct_answers": [_confident_reject(theme)],
                "explanation": "A counter-detail weakens the competing idea.",
                "hints": ["Find the sentence that says an idea fits poorly."],
            },
            {
                "id": str(uuid.uuid4()),
                "subject": "reading",
                "type": "multipleChoice",
                "prompt": "What should the team do next, according to the passage?",
                "choices": _confident_next_choices(theme),
                "correct_answers": [_confident_next(theme)],
                "explanation": "The closing plan is stated near the end.",
                "hints": ["Check the proposed next step."],
            },
        ],
    },
}


# ---------------------------------------------------------------------------
# Grossly different math banks per band (operations, ranges, question types)
# ---------------------------------------------------------------------------

MATH_CONTENT: dict[str, dict[str, Any]] = {
    "Emerging": {
        "operations": ["count", "compare"],
        "number_range": (1, 10),
        "question_types": ["count_set", "more_less"],
        "instructions_extra": "Count with your fingers if you need help.",
        "builder": lambda theme: _build_emerging_math(theme),
    },
    "Developing": {
        "operations": ["add", "subtract"],
        "number_range": (1, 10),
        "question_types": ["add_within_10", "subtract_within_10"],
        "instructions_extra": "Use pictures or tally marks for each step.",
        "builder": lambda theme: _build_developing_math(theme),
    },
    "Secure": {
        "operations": ["add", "subtract", "place_value"],
        "number_range": (1, 20),
        "question_types": ["add_within_20", "two_digit_tens", "one_step_word"],
        "instructions_extra": "Show your thinking in two steps when needed.",
        "builder": lambda theme: _build_secure_math(theme),
    },
    "Advancing": {
        "operations": ["multi_step", "multiply_intro", "fraction_unit"],
        "number_range": (1, 100),
        "question_types": ["two_step_word", "equal_groups", "unit_fraction"],
        "instructions_extra": "Plan the steps before computing. Check units.",
        "builder": lambda theme: _build_advancing_math(theme),
    },
}


# --- Beginner helpers ---

def _beginner_correct(theme: str) -> str:
    return {
        "Ocean": "a shell",
        "Space": "a star",
        "Dinosaurs": "a leaf",
        "Horses": "an apple",
        "Sharks": "a fish",
    }.get(theme, "a shell")


def _beginner_choices(theme: str) -> list[str]:
    correct = _beginner_correct(theme)
    other = {
        "Ocean": "a truck",
        "Space": "a sock",
        "Dinosaurs": "a phone",
        "Horses": "a kite",
        "Sharks": "a chair",
    }.get(theme, "a truck")
    # Keep distractors plausible within early world — simple wrong object from same story world
    soft = {
        "Ocean": "a wave",
        "Space": "a moon",
        "Dinosaurs": "an egg",
        "Horses": "grass",
        "Sharks": "kelp",
    }.get(theme, "a wave")
    return [correct, soft] if soft != correct else [correct, other]


def _beginner_sound(theme: str) -> str:
    return {
        "Ocean": "Splash",
        "Space": "Twinkle",
        "Dinosaurs": "Crunch",
        "Horses": "Yum",
        "Sharks": "Whoosh",
    }.get(theme, "Splash")


def _beginner_sound_choices(theme: str) -> list[str]:
    correct = _beginner_sound(theme)
    alt = {
        "Ocean": "Beep",
        "Space": "Moo",
        "Dinosaurs": "Ring",
        "Horses": "Zoom",
        "Sharks": "Clang",
    }.get(theme, "Beep")
    return [correct, alt]


# --- Early helpers ---

def _early_place(theme: str) -> str:
    return {
        "Ocean": "near a reef",
        "Space": "beside a moon rock",
        "Dinosaurs": "at a watering hole",
        "Horses": "on a dusty trail",
        "Sharks": "under bright kelp",
    }.get(theme, "near a reef")


def _early_place_choices(theme: str) -> list[str]:
    c = _early_place(theme)
    return [c, "in a classroom", "on a city bus"]


def _early_ending(theme: str) -> str:
    return {
        "Ocean": "Willa swims back to the reef",
        "Space": "They practice the path again",
        "Dinosaurs": "They sit and chew together",
        "Horses": "Sunny trots home along the trail",
        "Sharks": "Willa cheers for the peaceful swim",
    }.get(theme, "Willa swims back to the reef")


def _early_ending_choices(theme: str) -> list[str]:
    c = _early_ending(theme)
    return [c, "They fly to another planet", "They build a giant tower"]


def _early_detail(theme: str) -> str:
    return {
        "Ocean": "three smooth stones",
        "Space": "two safe landing spots",
        "Dinosaurs": "four fern leaves",
        "Horses": "ripe apples on a low branch",
        "Sharks": "five tiny fish",
    }.get(theme, "three smooth stones")


def _early_detail_choices(theme: str) -> list[str]:
    c = _early_detail(theme)
    return [c, "a hundred rockets", "a marching parade"]

# --- Growing helpers ---

def _growing_main(theme: str) -> str:
    return {
        "Ocean": "Healthy coral gives fish shelter and food",
        "Space": "Careful supply checks keep the moon crew safe",
        "Dinosaurs": "Careful looking turns fossil clues into a clearer story",
        "Horses": "The ride teaches noticing patterns, not racing",
        "Sharks": "Reef sharks can help keep ocean homes balanced",
    }.get(theme, "Healthy coral gives fish shelter and food")


def _growing_main_choices(theme: str) -> list[str]:
    c = _growing_main(theme)
    return [c, "The characters want to win a race", "The weather report is the only topic"]


def _growing_support(theme: str) -> str:
    return {
        "Ocean": "Coral nooks give shelter and a place to find food",
        "Space": "Nova reads the supply list while a robot confirms each count",
        "Dinosaurs": "The group sketches ridges and measures shell width",
        "Horses": "Riders compare deep prints to lighter ones",
        "Sharks": "Sharks help remove weak or sick fish",
    }.get(theme, "Coral nooks give shelter and a place to find food")


def _growing_support_choices(theme: str) -> list[str]:
    c = _growing_support(theme)
    return [c, "The characters want to win a race", "The weather is the only topic"]


def _growing_why(theme: str) -> str:
    return {
        "Ocean": "To track sheltering spots before the tide shifts",
        "Space": "To keep the outpost crew safely supplied",
        "Dinosaurs": "To turn scattered clues into a clearer story",
        "Horses": "To notice patterns without startling wildlife",
        "Sharks": "To share data with marine educators",
    }.get(theme, "To track sheltering spots before the tide shifts")


def _growing_why_choices(theme: str) -> list[str]:
    c = _growing_why(theme)
    return [c, "To finish first in a contest", "To ignore the evidence"]


# --- Confident helpers ---

def _confident_infer(theme: str) -> str:
    return {
        "Ocean": "The north ledge took more storm damage than the south ledge",
        "Space": "Travel time on the crater path is longer than planned",
        "Dinosaurs": "Site A more clearly shows a nest interruption than Site B",
        "Horses": "The rail was likely kicked from inside the pasture",
        "Sharks": "Camera aim, not shark disappearance, explains the log gap",
    }.get(theme, "The north ledge took more storm damage than the south ledge")


def _confident_infer_choices(theme: str) -> list[str]:
    c = _confident_infer(theme)
    return [
        c,
        "The characters abandoned science entirely",
        "Nothing in the passage can be compared",
        "A single photo proved every claim instantly",
    ]


def _confident_evidence(theme: str) -> str:
    return {
        "Ocean": "South ledge still matches the older drawing while north does not",
        "Space": "Each rover arrived after the communication window",
        "Dinosaurs": "Adult footprints at Site A face outward as if leaving in a hurry",
        "Horses": "Hoof marks cluster on the pasture side and wooded bark scrapes are absent",
        "Sharks": "Blue filmed the drop-off; Green faced the sand flat",
    }.get(theme, "South ledge still matches the older drawing while north does not")


def _confident_evidence_choices(theme: str) -> list[str]:
    c = _confident_evidence(theme)
    return [
        c,
        "Someone likes the color blue",
        "The teams skipped writing any logs",
        "An unrelated sports score decided the case",
    ]


def _confident_reject(theme: str) -> str:
    return {
        "Ocean": "Water samples near both ledges test similar, so pollution-alone fits poorly",
        "Space": "Skipping tool checks conflicts with past surface failures",
        "Dinosaurs": "Missing prints at Site B are weaker because wind can erase tracks",
        "Horses": "No bark scrapes on the wooded side weaken the outside-push claim",
        "Sharks": "Stable kelp fish counts make total shark abandonment unlikely",
    }.get(theme, "Water samples near both ledges test similar, so pollution-alone fits poorly")


def _confident_reject_choices(theme: str) -> list[str]:
    c = _confident_reject(theme)
    return [
        c,
        "Because the author said so without reasons",
        "Because the cameras disliked dusk light as a joke",
        "Because math is unrelated to the logs",
    ]


def _confident_next(theme: str) -> str:
    return {
        "Ocean": "Plant nursery coral and monitor fish counts monthly",
        "Space": "Depart earlier while keeping safety checks",
        "Dinosaurs": "Measure shell thickness and soil layers further",
        "Horses": "Photograph the rail grain before finalizing the report",
        "Sharks": "Film both zones next week so counts can converge",
    }.get(theme, "Plant nursery coral and monitor fish counts monthly")


def _confident_next_choices(theme: str) -> list[str]:
    c = _confident_next(theme)
    return [c, "Delete all the evidence", "Stop observing permanently", "Invent numbers without diving"]


# --- Math builders (structurally different per level) ---

def _math_q(
    prompt: str,
    choices: list[str],
    correct: str,
    explanation: str,
    hints: list[str],
    operation: str,
    operands: list[int | float] | None = None,
) -> dict[str, Any]:
    return {
        "id": str(uuid.uuid4()),
        "subject": "math",
        "type": "multipleChoice",
        "prompt": prompt,
        "choices": choices,
        "correct_answers": [correct],
        "explanation": explanation,
        "hints": hints,
        "operation": operation,
        "operands": operands or [],
    }


def _theme_noun(theme: str) -> str:
    return {
        "Ocean": "seashells",
        "Space": "moon rocks",
        "Dinosaurs": "fern leaves",
        "Horses": "apples",
        "Sharks": "tiny fish",
    }.get(theme, "seashells")


def _theme_character(theme: str) -> str:
    return {
        "Ocean": "Willa",
        "Space": "Nova",
        "Dinosaurs": "Dottie",
        "Horses": "Sunny",
        "Sharks": "Willa",
    }.get(theme, "Willa")


def _build_emerging_math(theme: str) -> list[dict[str, Any]]:
    """Count and compare only — no addition equations."""
    noun = _theme_noun(theme)
    who = _theme_character(theme)
    return [
        _math_q(
            prompt=f"{who} sees this set: ● ● ● ●. How many {noun}?",
            choices=["3", "4", "5"],
            correct="4",
            explanation="Count each mark once: 1, 2, 3, 4.",
            hints=["Touch each dot as you count."],
            operation="count",
            operands=[4],
        ),
        _math_q(
            prompt=f"Group A has 2 {noun}. Group B has 5 {noun}. Which group has more?",
            choices=["Group A", "Group B", "They are equal"],
            correct="Group B",
            explanation="5 is greater than 2.",
            hints=["Which number is larger?"],
            operation="compare",
            operands=[2, 5],
        ),
        _math_q(
            prompt=f"{who} lines up 7 {noun}. What numeral matches the count?",
            choices=["6", "7", "8"],
            correct="7",
            explanation="The count is seven.",
            hints=["Say the number aloud."],
            operation="count",
            operands=[7],
        ),
    ]


def _build_developing_math(theme: str) -> list[dict[str, Any]]:
    """One-step add/sub within 10 — natural word problems."""
    noun = _theme_noun(theme)
    who = _theme_character(theme)
    # Fixed computable items for validator
    return [
        _math_q(
            prompt=(
                f"{who} collected 4 {noun} on the path. Then {who} found 2 more. "
                f"How many {noun} does {who} have now?"
            ),
            choices=["5", "6", "7"],
            correct="6",
            explanation="4 + 2 = 6.",
            hints=["Start at 4 and count on 2."],
            operation="add",
            operands=[4, 2],
        ),
        _math_q(
            prompt=(
                f"Seven {noun} were resting in a pile. Three {noun} were shared with a friend. "
                f"How many {noun} are left?"
            ),
            choices=["3", "4", "5"],
            correct="4",
            explanation="7 − 3 = 4.",
            hints=["Take away 3 from 7."],
            operation="subtract",
            operands=[7, 3],
        ),
        _math_q(
            prompt=f"{who} had 5 {noun}. {who} found 3 more. How many altogether?",
            choices=["7", "8", "9"],
            correct="8",
            explanation="5 + 3 = 8.",
            hints=["Add the two groups."],
            operation="add",
            operands=[5, 3],
        ),
    ]


def _build_secure_math(theme: str) -> list[dict[str, Any]]:
    """Within 20 + place-value thinking — different structure from developing."""
    noun = _theme_noun(theme)
    who = _theme_character(theme)
    return [
        _math_q(
            prompt=(
                f"{who} packed 12 {noun} in a crate. Then {who} added 5 more from a basket. "
                f"How many {noun} are in the crate now?"
            ),
            choices=["15", "16", "17", "18"],
            correct="17",
            explanation="12 + 5 = 17.",
            hints=["Add the ones: 2 + 5 = 7, keep the ten."],
            operation="add",
            operands=[12, 5],
        ),
        _math_q(
            prompt=f"What is the value of the tens digit in 14 {noun}?",
            choices=["1", "4", "10", "14"],
            correct="10",
            explanation="In 14, the tens digit stands for 10.",
            hints=["Tens are groups of ten."],
            operation="place_value",
            operands=[14, 10],
        ),
        _math_q(
            prompt=(
                f"A tray held 18 {noun}. Explorers used 6 for a display. "
                f"How many {noun} remained on the tray?"
            ),
            choices=["10", "11", "12", "13"],
            correct="12",
            explanation="18 − 6 = 12.",
            hints=["Subtract from 18."],
            operation="subtract",
            operands=[18, 6],
        ),
    ]


def _build_advancing_math(theme: str) -> list[dict[str, Any]]:
    """Multi-step, equal groups, unit fractions — not age-invented Quantile scores."""
    noun = _theme_noun(theme)
    who = _theme_character(theme)
    return [
        _math_q(
            prompt=(
                f"{who} gathered 20 {noun}, gave away 6, then found 9 more. "
                f"How many {noun} does {who} have now?"
            ),
            choices=["21", "22", "23", "25"],
            correct="23",
            explanation="20 − 6 = 14, then 14 + 9 = 23.",
            hints=["Do the giveaway first, then add the new find."],
            operation="multi_step",
            operands=[20, 6, 9],
        ),
        _math_q(
            prompt=(
                f"Crews sorted {noun} into 4 equal boxes with 3 {noun} in each box. "
                f"How many {noun} are there in all?"
            ),
            choices=["7", "10", "12", "14"],
            correct="12",
            explanation="4 groups of 3 is 12.",
            hints=["Think 3 + 3 + 3 + 3."],
            operation="multiply",
            operands=[4, 3],
        ),
        _math_q(
            prompt=(
                f"A research bar is broken into 4 equal parts. {who} shades 1 part. "
                f"What fraction is shaded?"
            ),
            choices=["1/2", "1/3", "1/4", "3/4"],
            correct="1/4",
            explanation="One of four equal parts is 1/4.",
            hints=["Denominator is the number of equal parts."],
            operation="fraction",
            operands=[1, 4],
        ),
    ]


class MockAILessonGenerator(AILessonGenerator):
    """Creates structured lessons from skill + levels without calling any API.

    Content banks differ by reading_level and math_level (passages, vocabulary
    density, question types, number ranges) — not a single template with
    swapped numerals.
    """

    @property
    def provider_name(self) -> str:
        return "MockAILessonGenerator"

    @property
    def runs_on_backend_only(self) -> bool:
        return True

    def generate(self, request: LessonGenerationRequest) -> dict[str, Any]:
        request.validate_privacy()

        reading = _reading_band(request.reading_level)
        math = _math_band(request.math_level)
        theme = _theme_from_interests(request.interests)
        reading_bank = READING_CONTENT[reading]
        math_bank = MATH_CONTENT[math]

        story_opening = reading_bank["story_openings"].get(
            theme, reading_bank["story_openings"]["Ocean"]
        )
        passage = reading_bank["passages"].get(theme, reading_bank["passages"]["Ocean"])
        reading_questions = reading_bank["sample_questions"](theme, passage)
        math_questions = math_bank["builder"](theme)

        subject = request.subject or "Reading"
        title = f"{theme}: {reading_bank['title_suffix']}"
        if subject.lower() == "math":
            title = f"{theme} Numbers — {math} Challenge"

        instructions = reading_bank["instructions"]
        if subject.lower() == "math":
            instructions = math_bank["instructions_extra"]

        activities = [
            {
                "type": request.activity_type or "story_practice",
                "title": "Explore the story",
                "description": story_opening,
            },
            {
                "type": "guided_practice",
                "title": "Practice the skill",
                "description": request.learning_objective
                or request.skill_statement
                or "Practice the target skill with the questions below.",
            },
        ]

        common_mistakes = self._common_mistakes(reading, math, subject)
        success_criteria = self._success_criteria(reading, math, subject)

        all_questions = reading_questions + math_questions
        if subject.lower() == "math":
            # Lead with math; keep a light reading check
            all_questions = math_questions + reading_questions[:1]
        elif subject.lower() == "reading":
            all_questions = reading_questions + math_questions[:1]

        return {
            "id": str(uuid.uuid4()),
            "title": title,
            "subject": subject,
            "theme": theme,
            "learning_objective": request.learning_objective
            or request.skill_statement
            or f"Practice {request.standard_skill_id}",
            "standard_skill_id": request.standard_skill_id,
            "intended_age": request.age_range,
            "intended_grade": request.grade,
            "intended_reading_level": reading,
            "intended_math_level": math,
            "instructions": instructions,
            "story_content": {
                "opening": story_opening,
                "passage": passage,
                "ending": f"Great work exploring {theme.lower()} ideas today!",
            },
            "story_opening": story_opening,
            "reading_passage": passage,
            "activities": activities,
            "questions": all_questions,
            "common_mistakes": common_mistakes,
            "success_criteria": success_criteria,
            "prerequisites": list(request.prerequisites),
            "mastered_skills": list(request.mastered_skills),
            "practice_skills": list(request.practice_skills),
            "learner_id": request.learner_id,
            "approval_status": "pendingValidation",
            "generator": self.provider_name,
            "reading_vocab_style": reading_bank["vocab_style"],
            "math_number_range": list(math_bank["number_range"]),
            "math_operations": list(math_bank["operations"]),
        }

    @staticmethod
    def _common_mistakes(reading: str, math: str, subject: str) -> list[str]:
        mistakes = []
        if reading == "Beginner":
            mistakes.append("Matching the picture to a similar-looking wrong object")
        elif reading == "Early Reader":
            mistakes.append("Remembering a detail from the opening but not the ending")
        elif reading == "Growing Reader":
            mistakes.append("Choosing a detail instead of the main idea")
        else:
            mistakes.append("Making an inference that is not supported by cited evidence")

        if math == "Emerging":
            mistakes.append("Double-counting objects in a set")
        elif math == "Developing":
            mistakes.append("Adding when the story requires taking away")
        elif math == "Secure":
            mistakes.append("Confusing the tens value with the tens digit itself")
        else:
            mistakes.append("Completing only the first step of a multi-step problem")
        return mistakes

    @staticmethod
    def _success_criteria(reading: str, math: str, subject: str) -> list[str]:
        return [
            f"Answers reading items aligned to {reading} expectations",
            f"Completes math items within the {math} operation set",
            "Uses only information taught in this lesson's story or worked examples",
            "Selects a single correct answer from plausible choices",
        ]


def build_request_from_skill(
    skill: Skill,
    *,
    age_range: str,
    grade: str,
    reading_level: str,
    math_level: str,
    interests: list[str] | None = None,
    mastered_skills: list[str] | None = None,
    practice_skills: list[str] | None = None,
    learner_id: str | None = None,
    activity_type: str = "story_practice",
) -> LessonGenerationRequest:
    return LessonGenerationRequest(
        age_range=age_range,
        grade=grade,
        reading_level=reading_level,
        math_level=math_level,
        learning_objective=skill.full_statement,
        standard_skill_id=skill.identifier,
        prerequisites=list(skill.prerequisite_ids),
        mastered_skills=list(mastered_skills or []),
        practice_skills=list(practice_skills or []),
        interests=list(interests or ["Ocean"]),
        activity_type=activity_type,
        learning_outcome=f"Demonstrate: {skill.full_statement}",
        learner_id=learner_id,
        subject=skill.subject,
        skill_statement=skill.full_statement,
    )
