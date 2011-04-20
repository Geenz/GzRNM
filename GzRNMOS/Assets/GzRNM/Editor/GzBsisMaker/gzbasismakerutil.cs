using UnityEngine;
using UnityEditor;
using System.Collections;

public class GzBasisMakerUtil : Editor
{
    public static void MakeBasis(string name, Vector4 basisx, Vector4 basisy, Vector4 basisz)
    {
        Color[] cBasisx;
        Color[] cBasisy;
        Color[] cBasisz;
        Texture2D texBasisx = new Texture2D(16, 16);
        Texture2D texBasisy = new Texture2D(16, 16);
        Texture2D texBasisz = new Texture2D(16, 16);

        cBasisx = texBasisx.GetPixels();
        cBasisy = texBasisy.GetPixels();
        cBasisz = texBasisz.GetPixels();

        for (int i = 0; i < cBasisx.Length; i++)
        {
            cBasisx[i] = CompressedBasis(basisx);
            cBasisy[i] = CompressedBasis(basisy);
            cBasisz[i] = CompressedBasis(basisz);
        }

        texBasisx.SetPixels(cBasisx);
        texBasisy.SetPixels(cBasisy);
        texBasisz.SetPixels(cBasisz);
        if (!System.IO.Directory.Exists("Assets/GzRNM/BasisMaps"))
            System.IO.Directory.CreateDirectory("Assets/GzRNM/BasisMaps");
        GzCRNMMergeUtil.TextureImportHelper(texBasisx, "Assets/GzRNM/BasisMaps/Basis X.png");
        GzCRNMMergeUtil.TextureImportHelper(texBasisy, "Assets/GzRNM/BasisMaps/Basis Y.png");
        GzCRNMMergeUtil.TextureImportHelper(texBasisz, "Assets/GzRNM/BasisMaps/Basis Z.png");
    }

    public static Color CompressedBasis(Vector4 basis)
    {
        Color convB = new Color();
        convB.r = (basis.x + 1) / 2;
        convB.g = (basis.y + 1) / 2;
        convB.b = (basis.z + 1) / 2;
		convB.a = (1);
        return convB;
    }
}
