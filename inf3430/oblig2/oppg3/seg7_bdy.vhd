library IEEE;
use IEEE.std_logic_1164.all;
use ieee.numeric_std.all;


package body seg7_pkg is

function four2eightByte (indata: in std_logic_vector; dec : in std_logic) return std_logic_vector is

	 variable abcdefg_n : std_logic_vector(7 downto 0);
	begin   
		 
		if dec = '0' then	  
			case indata(3 downto 0) is
			  when "0000" => abcdefg_n := "00000011"; --0
			  when "0001" => abcdefg_n := "10011111"; --1
			  when "0010" => abcdefg_n := "00100101"; --2
			  when "0011" => abcdefg_n := "00001101"; --3
			  when "0100" => abcdefg_n := "10011001"; --4
			  when "0101" => abcdefg_n := "01001001"; --5
			  when "0110" => abcdefg_n := "01000001"; --6
			  when "0111" => abcdefg_n := "00011111"; --7
			  when "1000" => abcdefg_n := "00000001"; --8
			  when "1001" => abcdefg_n := "00011001"; --9
			  when "1010" => abcdefg_n := "00010001"; --A
			  when "1011" => abcdefg_n := "11000001"; --B
			  when "1100" => abcdefg_n := "01100011"; --C
			  when "1101" => abcdefg_n := "10000101"; --D
			  when "1110" => abcdefg_n := "01100001"; --E
			  when "1111" => abcdefg_n := "01110001"; --F
			  when others  => abcdefg_n := "XXXXXXXX";
			end case;                   
			
		elsif dec = '1' then
			case indata(3 downto 0) is
			  when "0000" => abcdefg_n := "00000010"; --0.
			  when "0001" => abcdefg_n := "10011110"; --1.
			  when "0010" => abcdefg_n := "00100100"; --2.
			  when "0011" => abcdefg_n := "00001100"; --3.
			  when "0100" => abcdefg_n := "10011000"; --4.
			  when "0101" => abcdefg_n := "01001000"; --5.
			  when "0110" => abcdefg_n := "01000000"; --6.
			  when "0111" => abcdefg_n := "00011110"; --7.
			  when "1000" => abcdefg_n := "00000000"; --8.
			  when "1001" => abcdefg_n := "00011000"; --9.
			  when "1010" => abcdefg_n := "00010000"; --A.
			  when "1011" => abcdefg_n := "11000000"; --B.
			  when "1100" => abcdefg_n := "01100010"; --C.
			  when "1101" => abcdefg_n := "10000100"; --D.
			  when "1110" => abcdefg_n := "01100000"; --E.
			  when "1111" => abcdefg_n := "01110000"; --F.
			  when others  => abcdefg_n := "XXXXXXXX";
			end case;
			end if;
		return abcdefg_n;
	end four2eightByte;
end seg7_pkg;