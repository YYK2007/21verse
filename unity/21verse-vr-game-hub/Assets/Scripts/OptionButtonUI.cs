using UnityEngine;
using UnityEngine.UI;

public class OptionButtonUI : MonoBehaviour
{
    public Image letterImage;       // child image to show the letter
    public Image backgroundImage;   // optional (assign Button's targetGraphic)
    [Header("Colors")]
    public Color idle = Color.white;
    public Color correct = Color.green;
    public Color wrong = Color.red;
    public Color disabled = new Color(1,1,1,0.5f);

    [HideInInspector] public bool IsCorrect;

    private Button btn;
    private WordGameControllerUI controller;

    void Awake()
    {
        btn = GetComponent<Button>();
        if (!backgroundImage) backgroundImage = GetComponent<Image>();
    }

    public void Bind(WordGameControllerUI controller, Sprite letter, bool isCorrect)
    {
        this.controller = controller;
        this.IsCorrect = isCorrect;
        if (letterImage) letterImage.sprite = letter;
        SetIdle();
        btn.interactable = true;
        btn.onClick.RemoveAllListeners();
        btn.onClick.AddListener(OnClick);
    }

    void OnClick()
    {
        if (controller) controller.SubmitAnswer(this);
    }

    public void SetIdle()      { if (backgroundImage) backgroundImage.color = idle; }
    public void SetCorrect()   { if (backgroundImage) backgroundImage.color = correct; btn.interactable = false; }
    public void SetWrong()     { if (backgroundImage) backgroundImage.color = wrong; btn.interactable = false; }
    public void SetDisabled()  { if (backgroundImage) backgroundImage.color = disabled; btn.interactable = false; }
    public void ResetVisual()
    {
        SetIdle();
        btn.interactable = true;
    }
}
