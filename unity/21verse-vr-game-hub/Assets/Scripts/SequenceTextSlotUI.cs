using UnityEngine;
using TMPro;
using UnityEngine.UI;

[DisallowMultipleComponent]
[RequireComponent(typeof(RectTransform))]
public class SequenceTextSlotUI : MonoBehaviour
{
    [Header("Refs")]
    public TextMeshProUGUI label;      // assign the same object’s TMP (or a child TMP)

    [Header("Sizing (keeps slot visible even when empty)")]
    public bool enforceFixedSize = true;
    public float minWidth  = 140f;
    public float minHeight = 140f;

    [Header("Appearance")]
    public Color textColor = new Color(0.13f, 0.13f, 0.13f);

    [Tooltip("If ON: use a Unicode outline box (□). If OFF: use TMP <mark> to draw a filled box.")]
    public bool useGlyphBox = true;

    [Tooltip("Outline box glyph when useGlyphBox = true")]
    public string missingGlyph = "□";  // alternatives: "◻", "⬜", "☐"
    [Range(0.5f, 2f)] public float glyphScale = 1.2f; // size multiplier for the glyph

    [Tooltip("Filled box color when useGlyphBox = false (ARGB hex)")]
    public string markColorHex = "#FFF4CCFF"; // pale yellow
    [Tooltip("Width of the filled box (number of non-breaking spaces inside <mark>)")]
    public int markSpaces = 6;                // adjust to your font/scale

    LayoutElement le;

    void Reset()
    {
        // Try to auto-grab a TMP on this object or children
        label = GetComponent<TextMeshProUGUI>();
        if (!label) label = GetComponentInChildren<TextMeshProUGUI>(true);
    }

    void Awake()
    {
        if (!label)
        {
            label = GetComponent<TextMeshProUGUI>();
            if (!label) label = GetComponentInChildren<TextMeshProUGUI>(true);
        }

        if (enforceFixedSize)
        {
            le = GetComponent<LayoutElement>();
            if (!le) le = gameObject.AddComponent<LayoutElement>();
            le.minWidth = minWidth;
            le.minHeight = minHeight;
            le.preferredWidth = minWidth;
            le.preferredHeight = minHeight;
        }

        if (label)
        {
            label.raycastTarget = false;
            label.richText = true;
            label.alignment = TextAlignmentOptions.Center;
            label.enableWordWrapping = false;
            label.color = textColor;
        }
    }

    /// Normal slot: show the number (plain text)
    public void SetValue(int value)
    {
        if (!label) return;
        label.color = textColor;
        label.text = value.ToString();
        gameObject.SetActive(true);
    }

    /// Missing slot: show a box instead of a number
    public void SetMissing()
    {
        if (!label) return;

        if (useGlyphBox)
        {
            // Outline box as a bigger glyph
            label.text = $"<size={(int)(glyphScale * 100f)}%>{missingGlyph}</size>";
        }
        else
        {
            // Filled box using <mark>; use non-breaking spaces to create width
            string spaces = new string('\u00A0', Mathf.Max(1, markSpaces));
            label.text = $"<mark={markColorHex}>{spaces}</mark>";
        }

        gameObject.SetActive(true);
    }

    /// After correct: replace box with the actual number
    public void FillWithAnswer(int value)
    {
        if (!label) return;
        label.color = textColor;
        label.text = value.ToString();
    }
}
