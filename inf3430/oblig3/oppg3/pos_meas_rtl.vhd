library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

architecture rtl of pos_meas is
	type state_type is (start_up_st, wait_a0_st, wait_a1_st, up_down_st, count_up_st, count_down_st);
	signal PRESENT_STATE, NEXT_STATE : state_type; 
	signal a_int : std_logic;
	signal b_int : std_logic;
	signal pos_i : signed(7 downto 0);

begin
	RESET_RUN:
	process(clk, rst) is
	begin
		if rst = '1' or sync_rst = '1' then
			PRESENT_STATE <= start_up_st;
		elsif rising_edge(clk) then
			PRESENT_STATE <= NEXT_STATE;
			a_int <= a;
			b_int <= b;
		end if;
	end process RESET_RUN;
	

	STATE_MACHINE:
	process (a_int, b_int, PRESENT_STATE) is
	begin
		case PRESENT_STATE is
			when up_down_st =>
				if b_int = '1' then
					NEXT_STATE <= count_down_st;					
				else 
					NEXT_STATE <= count_up_st;
				end if;		
			when wait_a0_st =>
				if a_int = '0' then 
					NEXT_STATE <= up_down_st;
				else
					NEXT_STATE <= wait_a0_st;
				end if;
			when wait_a1_st =>
				if a_int = '1' then
					NEXT_STATE <= wait_a0_st;
				else 
					NEXT_STATE <= wait_a1_st;
				end if;
			when start_up_st =>
				pos_i <= (others => '0');
				if a_int = '1' then 
					NEXT_STATE <= wait_a0_st;
				else 
					NEXT_STATE <= wait_a1_st;
				end if;
			when count_up_st =>
				if pos_i < "01111111" then
					pos_i <= pos_i + 1;
				end if;
				NEXT_STATE <= wait_a1_st;
			when count_down_st =>
				if pos_i > "00000000" then
					pos_i <= pos_i - 1;
				end if;
				NEXT_STATE <= wait_a1_st;
		end case;
	end process STATE_MACHINE;
	pos <= pos_i;			
	
end	architecture;
