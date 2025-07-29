@{
  ModuleName    = 'cliHelper.xconvert'
  ModuleVersion = [version]'0.1.9'
  ReleaseNotes  = @"
# Changelog`n`n

## v0.1.9 - Complete Method Pairs & SID Support

### ✅ New Features
- **Complete From/To Method Pairs**: Added all missing 'From' methods to complement existing 'To' methods
  - FromReverse, FromSecurestring, FromGuid, FromBoolean, FromChars
  - FromBitArrayString, FromSerialized, FromHashTable, FromDataTable
  - FromDateTime, FromOrdered, FromPSCustomObject, FromFlatObject, FromString
- **SID Conversion Support**: New ToSID and FromSID methods for Windows Security Identifier conversion
  - Support for 75+ well-known SIDs (Everyone, Administrators, Users, etc.)
  - Automatic translation between account names and SIDs
  - Proper error handling for invalid SIDs/accounts

### 🔧 Improvements
- Enhanced type safety and validation across all methods
- Better error messages with detailed context
- Consistent method signatures following established patterns

### 📋 Previous Changes (v0.1.8)
- Argument completer makes sense now :)
- Easy method chaining and Pipeline stuff
- Added argument completion for method names
- Fixed base85
- Added SID class for well-known SIDs

`n`n***`n`n## Manual install guide`n`n
1. [Click here](https://github.com/chadnpc/cliHelper.xconvert/releases/download/v<versionToDeploy>/cliHelper.xconvert.zip) to download the *PsImport.zip* file attached to the release.
2. **If on Windows**: Right-click the downloaded zip, select Properties, then unblock the file.
    > _This is to prevent having to unblock each file individually after unzipping._
3. Unzip the archive.
4. (Optional) Place the module folder somewhere in your ``PSModulePath``.
    > _You can view the paths listed by running the environment variable ```$Env:PSModulePath``_
5. Import the module, using the full path to the PSD1 file in place of ``cliHelper.xconvert`` if the unzipped module folder is not in your ``PSModulePath``:
    ``````powershell
    # In Env:PSModulePath
    Import-Module cliHelper.xconvert

    # Otherwise, provide the path to the manifest:
    Import-Module -Path Path\to\cliHelper.xconvert\<versionToDeploy>\cliHelper.xconvert.psd1
    ``````
"@
}