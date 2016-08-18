using UnityEngine;
using System.Collections;

[ExecuteInEditMode]
public class BSC_ImageEffect : MonoBehaviour {
	public Shader curShader;
	private Material curMaterial;

	public float brightnessAmount=1f;
	public float saturationAmount = 1f;
	public float contrastAmount =1f;
	
	Material material{
		get{
			if(curMaterial ==null)
			{
				curMaterial = new Material(curShader);
				curMaterial.hideFlags = HideFlags.HideAndDontSave;
				
			}
			return curMaterial;
		}
	}
	
	// Use this for initialization
	void Start () {
		
		if(! SystemInfo.supportsImageEffects)
		{
			enabled=false;
			return;
		}
		
		if(!curShader && !curShader.isSupported)
		{
			enabled = false;
		}
	}
	
	void OnRenderImage(RenderTexture sourceTexture, RenderTexture destTexture)
	{
		
		if(curShader !=null)
		{
			//Debug.Log("image");
			material.SetFloat("_BrightnessAmount",brightnessAmount);
			material.SetFloat("_satAmount",saturationAmount);
			material.SetFloat("_conAmount",contrastAmount);
			Graphics.Blit(sourceTexture,destTexture,material);
		}
		else {
			Graphics.Blit (sourceTexture,destTexture);
		}
	}
	// Update is called once per frame
	void Update () {
		brightnessAmount = Mathf.Clamp(brightnessAmount,0f,1f);
		saturationAmount = Mathf.Clamp(saturationAmount,0f,2f);
		contrastAmount = Mathf.Clamp(contrastAmount,0f,3f);
	}
	
	void OnDisable()
	{
		if(curShader)
		{
			DestroyImmediate(curMaterial);
		}
	}
}
