using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Drop : MonoBehaviour
{
    public bool active;

    public float time;

    public float acc;

    private float speed = 0;

    public bool last = false;

    public bool done = true;

    public Drop next;

    private AudioSource audioS;

    public AudioClip thump;

    public float speedLimit;

    public MeshRenderer[] meshRenderers;

    public GameObject anima;

    public float limit;
    //public float speed;
    // Start is called before the first frame update
    void Start()
    {
        if(time != 0)
            Invoke("Activate", time);
        audioS = GetComponent<AudioSource>();
    }

    // Update is called once per frame
    void Update()
    {
        if(active)
        {
            transform.position -= Vector3.up * speed;
            if(speed < speedLimit)
                speed += acc;
            if(transform.position.y <= limit)
            {
                active = false;
                transform.position = new Vector3(transform.position.x, limit, transform.position.z);
                audioS.PlayOneShot(thump);
                audioS.Play();
            }
        }
        if(!done)
        {
            if(!last)
            {
                if(!audioS.isPlaying)
                {
                    done = true;
                    next.Activate();
                }
                else
                {
                    if(Input.GetKeyDown(KeyCode.Space))
                    {
                        audioS.Stop();
                    }
                }
            }
        }
        
        
    }

    public void Activate()
    {
        active = true;
        done = false;
        
        for(int i = 0; i < meshRenderers.Length; i++)
        {
            meshRenderers[i].enabled = true;
        }

        if(last)
        {
            Invoke("ActivateGirl",57);
        }
    }

    public void ActivateGirl()
    {
        anima.SetActive(true);
    }
}
