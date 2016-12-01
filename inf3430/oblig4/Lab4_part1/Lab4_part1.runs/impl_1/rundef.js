//
// Vivado(TM)
// rundef.js: a Vivado-generated Runs Script for WSH 5.1/5.6
// Copyright 1986-2015 Xilinx, Inc. All Rights Reserved.
//

var WshShell = new ActiveXObject( "WScript.Shell" );
var ProcEnv = WshShell.Environment( "Process" );
var PathVal = ProcEnv("PATH");
if ( PathVal.length == 0 ) {
  PathVal = "W:/2015/vivado/SDK/2015.2/bin;W:/2015/vivado/Vivado/2015.2/ids_lite/ISE/bin/nt64;W:/2015/vivado/Vivado/2015.2/ids_lite/ISE/lib/nt64;W:/2015/vivado/Vivado/2015.2/bin;";
} else {
  PathVal = "W:/2015/vivado/SDK/2015.2/bin;W:/2015/vivado/Vivado/2015.2/ids_lite/ISE/bin/nt64;W:/2015/vivado/Vivado/2015.2/ids_lite/ISE/lib/nt64;W:/2015/vivado/Vivado/2015.2/bin;" + PathVal;
}

ProcEnv("PATH") = PathVal;

var RDScrFP = WScript.ScriptFullName;
var RDScrN = WScript.ScriptName;
var RDScrDir = RDScrFP.substr( 0, RDScrFP.length - RDScrN.length - 1 );
var ISEJScriptLib = RDScrDir + "/ISEWrap.js";
eval( EAInclude(ISEJScriptLib) );


// pre-commands:
ISETouchFile( "write_bitstream", "begin" );
ISEStep( "vivado",
         "-log Lab4_BD_wrapper.vdi -applog -m64 -messageDb vivado.pb -mode batch -source Lab4_BD_wrapper.tcl -notrace" );





function EAInclude( EAInclFilename ) {
  var EAFso = new ActiveXObject( "Scripting.FileSystemObject" );
  var EAInclFile = EAFso.OpenTextFile( EAInclFilename );
  var EAIFContents = EAInclFile.ReadAll();
  EAInclFile.Close();
  return EAIFContents;
}
