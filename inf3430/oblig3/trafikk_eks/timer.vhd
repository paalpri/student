	library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity TIMER is
  generic
    (
      N          : natural := 16
      );
  port
    (
      CLOCK       : in  std_logic;
      RESET       : in  std_logic;
      START_VAL   : in  std_logic_vector(N-1 downto 0);
      START_TIMER : in  std_logic;
      TIMED       : out std_logic
      );
end entity TIMER;

architecture RTL_TIMER_1 of TIMER is

  type   TIMER_STATE is (IDLE, CNTDOWN, TIMEOUT);
  signal TIMER_ST, NEXT_TIMER_ST : TIMER_STATE;
  signal TIMERCNT_LOAD           : std_logic;
  signal TIMERCNT_EN             : std_logic;
  signal TIMERCNT                : unsigned(N-1 downto 0);

begin
  --Stateregister
  STATE_REG :
  process (RESET, CLOCK) is
  begin
    if RESET = '1' then
      TIMER_ST <= IDLE;
    elsif (rising_edge(CLOCK)) then
      TIMER_ST <= NEXT_TIMER_ST;
    end if;
  end process STATE_REG;

  --Nextstate logic and output logic
  COMB :
  process (START_TIMER, TIMER_ST, TIMERCNT) is
  begin
    --Default verdier
    TIMED         <= '0';
    TIMERCNT_EN   <= '0';
    TIMERCNT_LOAD <= '0';
    NEXT_TIMER_ST <= IDLE;
    case TIMER_ST is
      when IDLE =>
        TIMERCNT_LOAD <= '1';
        if START_TIMER = '1' then
          NEXT_TIMER_ST <= CNTDOWN;
        else
          NEXT_TIMER_ST <= IDLE;
        end if;
      when CNTDOWN =>
        TIMERCNT_EN <= '1';
        if TIMERCNT = 0 then
          NEXT_TIMER_ST <= TIMEOUT;
        else
          NEXT_TIMER_ST <= CNTDOWN;
        end if;
      when TIMEOUT =>
        TIMED         <= '1';
        NEXT_TIMER_ST <= IDLE;
    end case;
  end process;

  TIMECOUNTER :
  process(RESET, CLOCK)
  begin
    if RESET = '1' then
      TIMERCNT <= unsigned(START_VAL);
    elsif rising_edge(clock) then
      if TIMERCNT_LOAD = '1' then
        TIMERCNT <= unsigned(START_VAL);
      elsif TIMERCNT_EN = '1' then
        TIMERCNT <= TIMERCNT-1;
      end if;
    end if;
  end process;
end architecture RTL_TIMER_1;


architecture RTL_TIMER_2 of TIMER is
  signal TIMERCNT : unsigned(N-1 downto 0);

begin
  TIMER:
  process (RESET,CLOCK)
  begin
    if RESET = '1' then
      TIMED <= '0';
      TIMERCNT <= (others => '0');
    elsif rising_edge(CLOCK) then
      TIMED    <= '0';
      if START_TIMER = '1' then
        TIMERCNT <= unsigned(START_VAL);
      elsif timercnt > 0 then
        TIMERCNT <= TIMERCNT - 1;
        if TIMERCNT = 1 then
          TIMED <= '1';
        end if;
      end if;
    end if;
  end process;  
  
end architecture RTL_TIMER_2;



