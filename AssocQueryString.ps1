#
# original code from https://stackoverflow.com/a/60972216
#
# modified to work with the 'assoc' built-in command
#
# C:\> assoc > assoc.txt
#
# (replace =.* with nothing to create a .ext file)
#
# C:\> .\AssocQueryString.ps1
#

$Signature = @"
﻿using System;
using System.Runtime.InteropServices;
using System.Text;
    public static class Win32Api
    {

        [DllImport("Shlwapi.dll", SetLastError = true, CharSet = CharSet.Auto)]
        static extern uint AssocQueryString(AssocF flags, AssocStr str, string pszAssoc, string pszExtra,[Out] System.Text.StringBuilder pszOut, ref uint pcchOut);


        public static string AssocQueryString(string extension)
        {
            return AssocQueryString(AssocF.None, AssocStr.Executable, extension);
        }

        internal static string AssocQueryString(AssocF assocF, AssocStr association, string assocString)
        {
            uint length = 0;
            uint ret = AssocQueryString(assocF, association, assocString, null, null, ref length);
            if (ret != 1) //expected S_FALSE
            {
                return null;
                //throw new InvalidOperationException("Could not determine associated string");
            }

            var sb = new System.Text.StringBuilder((int) length); //(length-1) will probably work too as null termination is added
            ret = AssocQueryString(assocF, association, assocString, null, sb, ref length);
            if (ret != 0) //expected S_OK
            {
                return null;
                //throw new InvalidOperationException("Could not determine associated string");
            }

            return sb.ToString();
        }


        [Flags]
        internal enum AssocF : uint
        {
            None = 0,
            Init_NoRemapCLSID = 0x1,
            Init_ByExeName = 0x2,
            Open_ByExeName = 0x2,
            Init_DefaultToStar = 0x4,
            Init_DefaultToFolder = 0x8,
            NoUserSettings = 0x10,
            NoTruncate = 0x20,
            Verify = 0x40,
            RemapRunDll = 0x80,
            NoFixUps = 0x100,
            IgnoreBaseClass = 0x200,
            Init_IgnoreUnknown = 0x400,
            Init_FixedProgId = 0x800,
            IsProtocol = 0x1000,
            InitForFile = 0x2000,
        }

        internal enum AssocStr
        {
            Command = 1,
            Executable,
            FriendlyDocName,
            FriendlyAppName,
            NoOpen,
            ShellNewValue,
            DDECommand,
            DDEIfExec,
            DDEApplication,
            DDETopic,
            InfoTip,
            QuickTip,
            TileInfo,
            ContentType,
            DefaultIcon,
            ShellExtension,
            DropTarget,
            DelegateExecute,
            SupportedUriProtocols,
            Max,
        }
    }
"@
Add-Type -TypeDefinition $Signature

foreach($assoc in Get-Content .\assoc.txt) {
    Write-Output "$assoc :: $([Win32Api]::AssocQueryString($assoc))"
}
