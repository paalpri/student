library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

package subprog_pck is
function func (parity: in std_logic) return std_logic;
function func (indata,parity : in std_logic) return std_logic;
procedure prosedyre (parity: inout std_logic);
procedure prosedyre (indata : in std_logic; parity: inout std_logic);

end subprog_pck;


package body subprog_pck is

function func (parity: in std_logic) return std_logic is
	begin
		return not parity;
	end func;
	
	function func (indata,parity : in std_logic) return std_logic is
	begin
		return (indata xor parity);
	end func;
	
	procedure prosedyre (parity: inout std_logic) is
	begin
		 parity := not parity;
	end prosedyre;
	
	procedure prosedyre (indata : in std_logic; parity: inout std_logic)is
	begin
		parity := parity xor indata; 
	end prosedyre;	
	
end subprog_pck;