using UnityEngine;
using UnityEngine.UI;
using TMPro;

[DisallowMultipleComponent]
[RequireComponent(typeof(RectTransform))]
public class SequenceBoxUI : MonoBehaviour
{
    [Header("Refs (on THIS object)")]
    public Button boxButton;                 // non-interactable; used just for its background
    public TextMeshProUGUI label;            // child TMP showing the number

    [Header("Box Style")]
    public Color fillColor   = new Color(0.86f, 0.92f, 1.00f, 1f); // light blue fill
    public Color borderColor = new Color(0.05f, 0.05f, 0.05f, 1f); // dark border
    [Range(0f, 6f)] public float borderThickness = 2f;            // outline thickness

    [Header("Sizing (avoid 0×0 collapse under layouts)")]
    public bool enforceMinSize = true;
    public Vector2 minSize = new Vector2(120, 120);

    // cached
    private Image bg;         // the button's target graphic
    private Outline outline;  // border effect

    void Reset()
    {
        // Try to auto-wire typical layout: Button + Image on this object, TMP as child
        boxButton = GetComponent<Button>();
        if (!boxButton) boxButton = gameObject.AddComponent<Button>();

        bg = GetComponent<Image>();
        if (!bg) bg = gameObject.AddComponent<Image>();

        if (!label) label = GetComponentInChildren<TextMeshProUGUI>(true);
    }

    void Awake()
    {
        // Ensure Button exists and is display-only
        if (!boxButton) boxButton = GetComponent<Button>();
        if (!boxButton) boxButton = gameObject.AddComponent<Button>();
        boxButton.interactable = false;
        boxButton.transition = Selectable.Transition.None;
        boxButton.navigation = new Navigation { mode = Navigation.Mode.None };

        // Target graphic = Image on same object
        bg = GetComponent<Image>();
        if (!bg) bg = gameObject.AddComponent<Image>();
        bg.raycastTarget = false;
        bg.color = fillColor;        // fill color
        bg.enabled = false;          // hidden by default (shown only on missing)
        bg.type = Image.Type.Simple; // we'll draw the border with Outline

        // Border via Outline effect (no sprite slicing needed)
        outline = GetComponent<Outline>();
        if (!outline) outline = gameObject.AddComponent<Outline>();
        outline.effectColor = borderColor;
        outline.effectDistance = new Vector2(borderThickness, -borderThickness);
        outline.useGraphicAlpha = true;
        outline.enabled = false;     // hidden by default

        // Label setup
        if (!label) label = GetComponentInChildren<TextMeshProUGUI>(true);
        if (label)
        {
            label.raycastTarget = false;
            label.alignment = TextAlignmentOptions.Center;
            label.enableWordWrapping = false;
        }

        // Keep a visible footprint even if empty text
        if (enforceMinSize)
        {
            var le = GetComponent<LayoutElement>();
            if (!le) le = gameObject.AddComponent<LayoutElement>();
            le.minWidth = minSize.x;
            le.minHeight = minSize.y;
            le.preferredWidth = minSize.x;
            le.preferredHeight = minSize.y;
        }
    }

    // ---------- API expected by your controller ----------

    // Normal slot: show number without box
    public void SetValue(int value)
    {
        if (bg) { bg.enabled = false; }
        if (outline) outline.enabled = false;

        if (label)
        {
            label.text = value.ToString();
            label.enabled = true;
        }

        gameObject.SetActive(true);
    }

    // Missing slot: show empty box (no number)
    public void SetMissing()
    {
        if (bg)
        {
            bg.color = fillColor;
            bg.enabled = true;        // show the “button” background
        }
        if (outline) outline.enabled = true; // border on
        if (label)   label.text = string.Empty;

        gameObject.SetActive(true);
    }

    // After correct: put the number inside; keep the box visible during the reveal
    public void FillWithAnswer(int value)
    {
        if (bg)      bg.enabled = true;   // keep box visible (like your screenshot)
        if (outline) outline.enabled = true;
        if (label)   label.text = value.ToString();
    }
}
