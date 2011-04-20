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

public class GzSSBumpConverterUtil : Editor {

    public static void FlattenSSBump(Texture2D Normal, bool flipXZ)
    {
        if (!flipXZ)
        {
            Texture2D SSBumpTex = new Texture2D(Normal.width, Normal.height, TextureFormat.RGB24, true);
            Color[] SSBumpColor;
            Color[] NormalColor;

            Vector4[] Basis = new Vector4[3];
            Basis[0] = new Vector4(0.816496580927726f, 0.0f, 0.5773502691896258f, 0.0f);
            Basis[1] = new Vector4(-0.408248290463863f, 0.7071067811865475f, 0.5773502691896258f, 0.0f);
            Basis[2] = new Vector4(-0.408248290463863f, -0.7071067811865475f, 0.5773502691896258f, 0.0f);


            //Make our Normal Texture readible temporarily
            TextureImporter tempRNMImport = TextureImporter.GetAtPath(AssetDatabase.GetAssetPath(Normal.GetInstanceID())) as TextureImporter;
            tempRNMImport.textureType = TextureImporterType.Image;
            tempRNMImport.isReadable = true;
            AssetDatabase.ImportAsset(AssetDatabase.GetAssetPath(Normal.GetInstanceID()), ImportAssetOptions.ForceUpdate);

            SSBumpColor = Normal.GetPixels();
            NormalColor = Normal.GetPixels();

            for (int i = 0; i < SSBumpColor.Length; i++)
            {
                SSBumpColor[i].r = (DotBasis(UnpackNormal(NormalColor[i]), Basis[0]) + 1) / 2;
                SSBumpColor[i].g = (DotBasis(UnpackNormal(NormalColor[i]), Basis[1]) + 1) / 2;
                SSBumpColor[i].b = (DotBasis(UnpackNormal(NormalColor[i]), Basis[2]) + 1) / 2;
            }

            SSBumpTex.SetPixels(SSBumpColor);
            GzCRNMMergeUtil.TextureImportHelper(SSBumpTex, AssetDatabase.GetAssetPath(Normal.GetInstanceID()) + "_SSBump.png");

            tempRNMImport.textureType = TextureImporterType.Bump;
            tempRNMImport.isReadable = false;
            AssetDatabase.ImportAsset(AssetDatabase.GetAssetPath(Normal.GetInstanceID()), ImportAssetOptions.ForceUpdate);
        }
        else
        {
            Color[] SSBumpColor;

            TextureImporter tempRNMImport = TextureImporter.GetAtPath(AssetDatabase.GetAssetPath(Normal.GetInstanceID())) as TextureImporter;
            tempRNMImport.isReadable = true;
            tempRNMImport.textureFormat = TextureImporterFormat.ARGB32;
            AssetDatabase.ImportAsset(AssetDatabase.GetAssetPath(Normal.GetInstanceID()), ImportAssetOptions.ForceUpdate);
            SSBumpColor = Normal.GetPixels();
            for (int i = 0; i < SSBumpColor.Length; i++)
            {
                SSBumpColor[i].a = SSBumpColor[i].b;
                SSBumpColor[i].b = SSBumpColor[i].g;
                SSBumpColor[i].g = SSBumpColor[i].a;
                SSBumpColor[i].a = 0.0f;
            }

            Normal.SetPixels(SSBumpColor);
            GzCRNMMergeUtil.TextureImportHelper(Normal, AssetDatabase.GetAssetPath(Normal.GetInstanceID()) + "_ConvertedSSBump.png");
            tempRNMImport.isReadable = false;
            AssetDatabase.ImportAsset(AssetDatabase.GetAssetPath(Normal.GetInstanceID()), ImportAssetOptions.ForceUpdate);
        }
    }

    public static Color UnpackNormal(Color normal)
    {
        normal.r = normal.a * 2 - 1;
        normal.g = normal.g * 2 - 1;
        normal.b = Mathf.Sqrt(1 - normal.r * normal.r - normal.g * normal.g);
        return normal;
    }

    public static float DotBasis(Color color, Vector4 basis)
    {
        return Vector4.Dot(color, basis);
    }
}
