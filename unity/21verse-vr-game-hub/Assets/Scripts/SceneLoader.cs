using UnityEngine;
using UnityEngine.SceneManagement;

public class SceneLoader : MonoBehaviour
{
    [Tooltip("Build index of scene to load")]
    public int buildIndex = 1;

    public void Load()
    {
        int count = SceneManager.sceneCountInBuildSettings;
        if (buildIndex < 0 || buildIndex >= count)
        {
            Debug.LogError($"SceneLoader: buildIndex {buildIndex} out of range (0..{count-1})");
            return;
        }
        SceneManager.LoadScene(buildIndex);
    }
}
