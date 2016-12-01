library IEEE;
use IEEE.std_logic_1164.all;

entity TRAFFIC is
  port
    (
      CLOCK       : in  std_logic;
      RESET       : in  std_logic;
      TIMED       : in  std_logic;
      CAR         : in  std_logic;
      START_TIMER : out std_logic;
      MAJOR_GREEN : out std_logic;
      MINOR_GREEN : out std_logic
      );
end entity TRAFFIC;

architecture RTL_TRAFFIC of TRAFFIC is

  type   state_type is (GREEN, RED);
  signal PRESENT_STATE, NEXT_STATE : state_type;

begin
  --Stateregister
  STATE_REG :
  process (CLOCK, RESET) is
  begin
    if RESET = '1' then
      PRESENT_STATE <= GREEN;
    elsif (rising_edge(CLOCK)) then
      PRESENT_STATE <= NEXT_STATE;
    end if;
  end process STATE_REG;

  --Nextstate logic and output logic
  COMB :
  process (CAR, TIMED, PRESENT_STATE) is
  begin
    START_TIMER <= '0';
    case PRESENT_STATE is
      when GREEN =>
        MAJOR_GREEN <= '1';
        MINOR_GREEN <= '0';
        if (CAR = '1') then
          START_TIMER <= '1';
          NEXT_STATE  <= RED;
        else
          NEXT_STATE <= GREEN;
        end if;
      when RED =>
        MAJOR_GREEN <= '0';
        MINOR_GREEN <= '1';
        if (TIMED = '1') then
          NEXT_STATE <= GREEN;
        else
          NEXT_STATE <= RED;
        end if;
    end case;
  end process COMB;

end architecture RTL_TRAFFIC;

