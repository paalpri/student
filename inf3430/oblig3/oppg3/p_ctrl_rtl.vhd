library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;


architecture RTL_P_CTRL of P_ctrl is

  type   state_type is (idle_st,sample_st,motor_st);
  signal PRESENT_STATE, NEXT_STATE : state_type;
  signal err   : signed(7 downto 0);
  signal pos_i : signed(7 downto 0);
  signal sp_i  : signed(7 downto 0);
  signal motor_cwi : std_logic;
  signal motor_ccwi : std_logic;

begin
  --Stateregister
  STATE_REG :
  process (clk, rst) is
  begin
    if rst = '1' then
      PRESENT_STATE <= idle_st;
    elsif (rising_edge(clk)) then
      PRESENT_STATE <= NEXT_STATE;
	  pos_i <= pos;
	  sp_i  <= sp;
    end if;
  end process STATE_REG;

  --Nextstate logic and output logic
  COMB :
  process (PRESENT_STATE) is
  begin

    case PRESENT_STATE is
      when idle_st =>
	   motor_cwi <= '0';
	   motor_ccwi <= '0';
        NEXT_STATE <= sample_st;
      when sample_st => 
        err <= sp_i - pos_i;
		NEXT_STATE <= motor_st;
	  when motor_st =>
			if err > 0 then 
				motor_ccwi <= '0';
				motor_cwi <= '1';
			else
				if err < 0 then
					motor_ccwi <= '1';
					motor_cwi <= '0';
				else
					motor_ccwi <= '0';
					motor_cwi <= '0';
				end if;
			end if;	
		NEXT_STATE <= sample_st;			
    end case;
  end process COMB;
  
  motor_cw <= motor_cwi;
  motor_ccw <= motor_ccwi;

end architecture RTL_P_CTRL;

