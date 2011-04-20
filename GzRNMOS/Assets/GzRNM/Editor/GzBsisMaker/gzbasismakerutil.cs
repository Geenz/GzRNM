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
