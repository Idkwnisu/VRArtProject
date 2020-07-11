using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.SceneManagement;

public class TapStart : MonoBehaviour
{
    // Start is called before the first frame update
    void Start()
    {
        
    }

    // Update is called once per frame
    void Update()
    {
        if (Input.touchCount > 0)
        {
            Touch touch = Input.GetTouch(0);
            if(touch.phase == TouchPhase.Began)
            {
                Invoke("StartScene", 5);
            }
        }
        if(Input.GetKeyDown(KeyCode.Space))
        {
            Invoke("StartScene", 5);
        }
    }

    public void StartScene()
    {
        SceneManager.LoadScene("HelloVR");
    }
}
