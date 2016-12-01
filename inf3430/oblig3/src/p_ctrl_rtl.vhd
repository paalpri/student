library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;


architecture RTL_P_CTRL of P_ctrl is

  type   state_type is (idle_st,sample_st,motot_st,);
  signal PRESENT_STATE, NEXT_STATE : state_type;
  signal err : signed(7 downto 0);
  signal pos_i : signed(7 downto 0);
  signal sp_i  : signed(7 downto 0);

begin
  --Stateregister
  STATE_REG :
  process (clk, rst) is
  begin
    if RESET = '1' then
      PRESENT_STATE <= idle_st;
	  motor_cw <= '0';
	  motor_ccw <= '0':
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
        NEXT_STATE <= sample_st;
      when sampel_st => 
        err <= sp_i - pos_i;
		NEXT_STATE <= motor_st:
	  when motor_st =>
	  NEXT_STATE <= sampel_st;
			if(err > 0) then 
				motor_ccw <= '0';
				motor_cw <= '1':
			else
				if(err < 0) then
					motor_ccw <= '1':
					motor_cw <= '0';
				else
					motor_ccw <= '0';
					motor_cw <= '0';
    end case;
  end process COMB;

end architecture RTL_P_CTRL;

