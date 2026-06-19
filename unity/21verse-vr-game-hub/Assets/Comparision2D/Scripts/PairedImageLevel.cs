using UnityEngine;

[CreateAssetMenu(menuName = "21Verse/Paired Image Level", fileName = "Paired Image Level")]
public class PairedImageLevel : ScriptableObject
{
    [Header("Dimension grouping (e.g., height, temperature)")]
    public string dimensionId;          // "height"

    [Header("Canonical tags for this dimension")]
    public string positiveTag;          // "tall"
    public string negativeTag;          // "short"

    [Header("Level content")]
    public Sprite leftSprite;
    public string leftTag;              // "tall" or "short"
    public Sprite rightSprite;
    public string rightTag;             // "tall" or "short"

    [Header("Prompt for this level")]
    public string askedTag;             // what you ask for in the recording (e.g., "tall")
    public AudioClip promptClip;        // your voice clip for this level
}
