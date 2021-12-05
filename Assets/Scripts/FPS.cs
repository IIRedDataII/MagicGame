using System.Globalization;
using UnityEngine;
using TMPro;

public class FPS : MonoBehaviour
{

    [SerializeField] private TextMeshProUGUI fpsPrompt;
    
    void Update()
    {
        
        fpsPrompt.text = Mathf.Round(1f / Time.deltaTime).ToString(CultureInfo.InvariantCulture);

    }
    
}
