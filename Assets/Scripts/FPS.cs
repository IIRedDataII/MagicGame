using System.Globalization;
using UnityEngine;
using TMPro;

public class FPS : MonoBehaviour
{
    
    private const float Delay = 1f / 4f;

    [SerializeField] private TextMeshProUGUI fpsPrompt;

    private float _timePassed;
    private int _fps;

    private void Start()
    {
        _timePassed = 0f;
        _fps = 60;
    }

    private void Update()
    {
        _fps = (int) Mathf.Round(1f / Time.deltaTime);
    }

    private void FixedUpdate()
    {
        if (_timePassed >= Delay)
        {
            fpsPrompt.text = _fps.ToString(CultureInfo.InvariantCulture);
            _timePassed = 0f;
        }
        _timePassed += Time.deltaTime;
    }

}
