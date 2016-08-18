using UnityEngine;
using System.Collections;

[ExecuteInEditMode]
public class TestRenderImage : MonoBehaviour {

	public Shader curShader;
	private Material curMaterial;
	public float grayScaleAmount =1.0f;

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
			material.SetFloat("_LuminosityAmount",grayScaleAmount);
			Graphics.Blit(sourceTexture,destTexture,material);
		}
		else {
			Graphics.Blit (sourceTexture,destTexture);
		}
	}
	// Update is called once per frame
	void Update () {
		grayScaleAmount = Mathf.Clamp(grayScaleAmount,0f,1f);
	}

	void OnDisable()
	{
		if(curShader)
		{
			DestroyImmediate(curMaterial);
		}
	}
}
