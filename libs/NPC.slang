
// library imports

// project imports


/*
"vivienne": {
    "name": "Vivienne Sinclair",
    "description": "A jazz singer with a mysterious past.",
    "personality": "Wary but charming. She hides fear behind wit.",
    "intro": {
        "text": "You again. I told you I don't know anything about Lorne.",
        "choices": [
            { "text": "I found this cufflink at your club.", "next": "cufflink" },
            { "text": "Come on, Viv. Talk to me.", "next": "soften" }
        ]
    },
    "soften": {
        "text": "Don't make me regret this. He was in trouble. Real trouble.",
        "choices": [{ "text": "What kind of trouble?", "next": "trouble" }]
    },
    "cufflink": {
        "condition": "found_cufflink",
        "text": "...Lorne always wore those. I told him not to come back here.",
        "choices": [{ "text": "Why?", "next": "warning" }]
    },
    "warning": {
        "text": "Because Leone was watching. And Lorne wasn’t careful.",
        "set_flag": "vivienne_warned_you"
    },
    "trouble": {
        "text": "He talked about a shipment, something he needed to hide. Maybe Mick knows more.",
        "set_flag": "sent_to_mick"
    }
}
*/

public object NPC
{
    public string description;
    public string id;
    public string name;
}
