using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.SceneManagement;
public class Anima : MonoBehaviour
{
    public GameObject player;
    public float speed;
    public float distance;

    public float speedAppear = 0.01f;
    private bool appearing = true;
    private bool disappearing = false;

    private float currentStep = 0.0f;

    public float height;

    public float heightFloatingAmount;
    public float heightFloatingSpeed;

    private Animator animator;

    public Material mat;

    // Start is called before the first frame update
    void Start()
    {
       Invoke("StartVoice",1); 
        Invoke("ChangeToThree",18); 
        Invoke("ChangeToFive",30); 
        Invoke("Disappear",39f); 
       animator = GetComponent<Animator>();
    }

    // Update is called once per frame
    void Update()
    {
        transform.LookAt(player.transform);
        float h = height + heightFloatingAmount * Mathf.Sin(Time.time * heightFloatingSpeed);
        transform.position = player.transform.position + distance * new Vector3(Mathf.Cos(Time.time * speed), h, Mathf.Sin(Time.time * speed));
    
        if(appearing)
        {
            if(currentStep < 1.0f)
            {
                currentStep += speedAppear;
            }
            else
            {
                appearing = false;
            }
            mat.SetFloat("_Step",currentStep);
        }
        if(disappearing)
        {
            if(currentStep > 0.0f)
            {
                currentStep -= speedAppear;
                 mat.SetFloat("_Step",currentStep);
            }
            else
            {
                Invoke("ChangeScene",2.0f);
               
                
            }

        }
    }

    public void ChangeScene()
    {
        SceneManager.LoadScene("Start");
         Destroy(gameObject);
    }

    public void StartVoice()
    {
        GetComponent<AudioSource>().Play();
    }

    public void ChangeToThree()
    {
        animator.SetBool("TwoThree", true);
        
    }

    public void ChangeToFive()
    {
        animator.SetBool("FourFive", true);
    }

    public void Disappear()
    {
        disappearing = true;
    }
}
