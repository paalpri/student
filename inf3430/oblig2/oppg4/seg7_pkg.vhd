library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

package seg7_pkg is
function four2eightByte (indata: in std_logic_vector; dec : in std_logic) return std_logic_vector;
end package seg7_pkg;


