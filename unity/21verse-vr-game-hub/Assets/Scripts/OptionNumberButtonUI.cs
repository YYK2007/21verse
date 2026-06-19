using UnityEngine;
using UnityEngine.UI;
using TMPro;

public class OptionNumberButtonUI : MonoBehaviour
{
    [Header("Refs")]
    public TextMeshProUGUI numberText;      // child TMP
    public Image backgroundImage;           // the Button's targetGraphic

    [Header("Colors")]
    public Color idle = Color.white;
    public Color correct = Color.green;
    public Color wrong = Color.red;
    public Color disabled = new Color(1,1,1,0.5f);

    [HideInInspector] public bool IsCorrect;
    [HideInInspector] public int Value;

    private Button btn;
    private NumberGameControllerUI controller;

    void Awake()
    {
        btn = GetComponent<Button>();
        if (!backgroundImage) backgroundImage = GetComponent<Image>();
    }

    public void Bind(NumberGameControllerUI controller, int value, bool isCorrect)
    {
        this.controller = controller;
        this.Value = value;
        this.IsCorrect = isCorrect;

        if (numberText) numberText.text = value.ToString();

        btn.interactable = true;
        SetIdle();
        btn.onClick.RemoveAllListeners();
        btn.onClick.AddListener(OnClick);
        gameObject.SetActive(true);
    }

    void OnClick()
    {
        if (controller) controller.SubmitAnswer(this);
    }

    public void SetIdle()     { if (backgroundImage) backgroundImage.color = idle; }
    public void SetCorrect()  { if (backgroundImage) backgroundImage.color = correct; btn.interactable = false; }
    public void SetWrong()    { if (backgroundImage) backgroundImage.color = wrong;   btn.interactable = false; }
    public void SetDisabled() { if (backgroundImage) backgroundImage.color = disabled; btn.interactable = false; }

    public void ResetVisual()
    {
        SetIdle();
        btn.interactable = true;
        gameObject.SetActive(true);
    }
}
