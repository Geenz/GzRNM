/*
    GzRNM - A shader library for Radiosity Normal Mapping in Unity3D!    
    Copyright (C) 2011  Jonathan Goodman

    This library is free software; you can redistribute it and/or
    modify it under the terms of the GNU Lesser General Public
    License as published by the Free Software Foundation; either
    version 2.1 of the License, or (at your option) any later version.

    This library is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
    Lesser General Public License for more details.

    You should have received a copy of the GNU Lesser General Public
    License along with this library; if not, write to the Free Software
    Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301  USA
*/

using UnityEngine;
using UnityEditor;
using System.Collections;

public class GzCRNMMergeUtil : Editor {

    public static void FlattenCRNM(Texture2D[] RNM)
    {
        //Initialize our new textures.
        Texture2D CRNMTex = new Texture2D(RNM[0].width, RNM[0].height, TextureFormat.RGB24, true);
        Texture2D CRNMNColorTex = new Texture2D(RNM[0].width, RNM[0].height, TextureFormat.RGB24, true);

        //Make our RNM Textures readible temporarily
        for (int i = 0; i < 3; i++)
        {
            TextureImporter tempRNMImport = TextureImporter.GetAtPath(AssetDatabase.GetAssetPath(RNM[i].GetInstanceID())) as TextureImporter;
            tempRNMImport.isReadable = true;
            AssetDatabase.ImportAsset(AssetDatabase.GetAssetPath(RNM[i].GetInstanceID()), ImportAssetOptions.ForceUpdate);
        }

        //Setup our Color values
        Color[] RNMXColor;
        Color[] RNMYColor;
        Color[] RNMZColor;

        RNMXColor = RNM[0].GetPixels();
        RNMYColor = RNM[1].GetPixels();
        RNMZColor = RNM[2].GetPixels();

        Color[] CRNMColor = new Color[RNMXColor.Length];
        Color[] CRNMNColor = new Color[RNMXColor.Length];

        //Unpack the light textures
        for (int i = 0; i < CRNMColor.Length; i++)
        {
            RNMXColor[i] = UnpackLightTexture(RNMXColor[i]);
            RNMYColor[i] = UnpackLightTexture(RNMYColor[i]);
            RNMZColor[i] = UnpackLightTexture(RNMZColor[i]);
        }

        //Create our directional lightmap
        for (int i = 0; i < CRNMColor.Length; i++)
        {
            CRNMColor[i].r = DesaturateRGB(RNMXColor[i]);
            CRNMColor[i].g = DesaturateRGB(RNMYColor[i]);
            CRNMColor[i].b = DesaturateRGB(RNMZColor[i]);
        }

        CRNMTex.SetPixels(CRNMColor);

        //Average and normalize each pixel in the texture.
        for (int i = 0; i < CRNMNColor.Length; i++)
        {
            CRNMNColor[i] = NormalizeRGB((RNMXColor[i] + RNMYColor[i] + RNMZColor[i]));
        }

        CRNMNColorTex.SetPixels(CRNMNColor);

        //Import our textures
        
        TextureImportHelper(CRNMTex, AssetDatabase.GetAssetPath(RNM[0].GetInstanceID()) + "_CRNM.png");
        TextureImportHelper(CRNMNColorTex, AssetDatabase.GetAssetPath(RNM[0].GetInstanceID()) + "_CRNM_Color.png");

        //Cleanup our texture importers
        for (int i = 0; i < 3; i++)
        {
            TextureImporter tempRNMImport = TextureImporter.GetAtPath(AssetDatabase.GetAssetPath(RNM[i].GetInstanceID())) as TextureImporter;
            tempRNMImport.isReadable = false;
            AssetDatabase.ImportAsset(AssetDatabase.GetAssetPath(RNM[i].GetInstanceID()), ImportAssetOptions.ForceUpdate);
        }
    }

    public static Color UnpackLightTexture(Color col)
    {
        return (8 * col.a) * col;
    }

    public static void TextureImportHelper(Texture2D tex, string path)
    {
        byte[] bytes = tex.EncodeToPNG();
        //path = path.Replace("", ".png");
        System.IO.File.WriteAllBytes(path, bytes);
        AssetDatabase.ImportAsset(path);
        AssetDatabase.Refresh();
    }

    public static Color NormalizeRGB(Color Color)
    {
        return Vector4.Normalize(Color);
    }

    public static float DesaturateRGB(Color Color)
    {
		//if(Color.r > 1.0 || Color.g > 1.0 || Color.b > 1.0)
		{
			Color.r = Color.r / 1;
            Color.g = Color.g / 1;
            Color.b = Color.b / 1;
		}
        return Vector4.Dot(Color, new Vector4(0.5f, 0.77f, 0.5f, 1f));
    }
}
