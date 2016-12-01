library IEEE;
use IEEE.std_logic_1164.all;

entity T_TRAFFICCTRL is
end entity T_TRAFFICCTRL;

architecture TEST_TRAFFICCTRL of T_TRAFFICCTRL is

  component TRAFFICCTRL is
    port
      (
        CLOCK       : in  std_logic;
        RESET       : in  std_logic;
        CAR         : in  std_logic;
        MAJOR_GREEN : out std_logic;
        MINOR_GREEN : out std_logic
        );
  end component trafficctrl;


  signal CLOCK       : std_logic := '0';
  signal RESET       : std_logic := '1';
  signal CAR         : std_logic := '0';
  signal MAJOR_GREEN : std_logic;
  signal MINOR_GREEN : std_logic;

begin

  TRAFFICCTRL_INST : TRAFFICCTRL
    port map
    (
      CLOCK       => CLOCK,
      RESET       => RESET,
      CAR         => CAR,
      MAJOR_GREEN => MAJOR_GREEN,
      MINOR_GREEN => MINOR_GREEN
      );

  CLOCK <= not CLOCK after 10 ns;

  STIMULI :
  process
  begin
    RESET <= '1', '0' after 100 ns;
    wait for 1 us;
    CAR   <= '1';
    wait for 200 ns;
    CAR   <= '0';
    wait;
  end process;

end architecture TEST_TRAFFICCTRL;
