library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity TRAFFICCTRL is
  port
    (
      CLOCK       : in  std_logic;
      RESET       : in  std_logic;
      CAR         : in  std_logic;
      MAJOR_GREEN : out std_logic;
      MINOR_GREEN : out std_logic
      );
end entity TRAFFICCTRL;

architecture RTL_TRAFFICCTRL of TRAFFICCTRL is
  
  constant width : POSITIVE:=4;
  
  signal START_TIMER : std_logic;
  signal TIMED       : std_logic;
  signal START_VAL   : std_logic_vector(width-1 downto 0); 
  
  component TRAFFIC is
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
  end component traffic;

  component TIMER is
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
  end component timer;



begin

  START_VAL <= std_logic_vector(to_unsigned(10,width));
  
  TIMER_INST : entity work.TIMER(RTL_TIMER_1)
    generic map
    (
      N => width
      )
    port map
    (
      CLOCK       => CLOCK,
      RESET       => RESET,
      START_VAL   => START_VAL,
      START_TIMER => START_TIMER,
      TIMED       => TIMED
      );

  TRAFFIC_INST : TRAFFIC
    port map
    (
      CLOCK       => CLOCK,
      RESET       => RESET,
      TIMED       => TIMED,
      CAR         => CAR,
      START_TIMER => START_TIMER,
      MAJOR_GREEN => MAJOR_GREEN,
      MINOR_GREEN => MINOR_GREEN
      );

end architecture RTL_TRAFFICCTRL;

