using UnityEngine;

public class CamDepth : MonoBehaviour
{
    public Material CasterMat = null;
    // public Material shadowCollectorMat = null;
    
    public int qulity = 2;
    [Range(-0.3f, 0.3f)]
    public float Bias = 0;
    public Camera lightCam;
    // public Camera depthCam;

    public RenderTexture lightDepthTexture;
    // RenderTexture depthTexture;
    // public RenderTexture screenSpaceShadowTexture;
    // public RenderTexture buffer0;

    private void Start()
    {
        lightDepthTexture = new RenderTexture(Screen.width * qulity, Screen.height * qulity, 24, RenderTextureFormat.Default);
        lightDepthTexture.hideFlags = HideFlags.DontSave;

        // depthTexture = new RenderTexture(Screen.width * qulity, Screen.height * qulity, 24, RenderTextureFormat.Default);
        // depthTexture.hideFlags = HideFlags.DontSave;

        // screenSpaceShadowTexture = new RenderTexture(Screen.width * qulity, Screen.height * qulity, 0, RenderTextureFormat.Default);
        // screenSpaceShadowTexture.hideFlags = HideFlags.DontSave;

        // buffer0 = RenderTexture.GetTemporary(Screen.width * qulity, Screen.height * qulity, 0, RenderTextureFormat.Default);
        // screenSpaceShadowTexture.hideFlags = HideFlags.DontSave;

        // depthCam.targetTexture = depthTexture;
        lightCam.targetTexture = lightDepthTexture;

        // Shader.SetGlobalTexture("_DepthTexture", depthTexture);
    }

    private void LateUpdate()
    {
        Shader.SetGlobalFloat("_Bias", Bias);
        Shader.SetGlobalFloat("_gShadowStrength", 0.5f);
        Shader.SetGlobalTexture("_gShadowMapTexture", lightDepthTexture);
        // depthCam.RenderWithShader(shadowCasterMat.shader, "");
        lightCam.RenderWithShader(CasterMat.shader, "");

        Matrix4x4 projectionMatrix = GL.GetGPUProjectionMatrix(lightCam.projectionMatrix, false);
        Shader.SetGlobalMatrix("_gWorldToShadow", projectionMatrix * lightCam.worldToCameraMatrix);

        // Matrix4x4 projectionMatrix = GL.GetGPUProjectionMatrix(Camera.main.projectionMatrix, false);
        //矩阵的相乘顺序从右至左，从世界空间-》摄像机空间-》裁剪空间，然后取逆
        // Shader.SetGlobalMatrix("_inverseVP", Matrix4x4.Inverse(projectionMatrix * Camera.main.worldToCameraMatrix));

        // shadowCollectorMat.SetTexture("_CameraDepthTex", depthTexture);
        // shadowCollectorMat.SetTexture("_LightDepthTex", lightDepthTexture);

        
        // Graphics.Blit(depthTexture, screenSpaceShadowTexture, shadowCollectorMat, 0);

        // shadowCollectorMat.SetTexture("_PCFTex", buffer0);

        // Graphics.Blit(buffer0, screenSpaceShadowTexture, shadowCollectorMat, 1);

        // Shader.SetGlobalTexture("_ScreenSpceShadowTexture", screenSpaceShadowTexture);
    }
}
