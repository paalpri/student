library ieee;
use  ieee.std_logic_1116.all;
use  ieee.numeric_std.all;


entity tb_oppg10 is
end entity tb_oppg10;

architecture testbench of tb_oppg10 is

  component arbiter
    port
      (
        rst : in std_logic;
        clk : in std_logic;
        breq : in std_logic_vector(2 downto 0);
        bgrant : out std_logic_vector(2 downto 0);
        btout : out std_logic_vector(2 downto 0);
        timer_rst : out std_logic;
        timer_en : out std_logic;
        timeout : in std_logic
        );
  end component;

  signal mclk : std_logic;
  signal rst : std_logic;
  signal breq :  std_logic_vector(2 downto 0);
  signal bgrant : out std_logic_vector(2 downto 0);
  signal btout : out std_logic_vector(2 downto 0);
  signal timer_rst : out std_logic;
  signal timer_en : out std_logic;
  signal timeout : in std_logic;

  constant half_period: time := 10 ns ;


begin

  uut: arbiter
    port map
    (
      rst => rst,
      clk => mclk,
      breq => breq,
      bgrant => bgrant,
      btout => btout,
      timer_rst => timer_rst,
      timer_en => timer_en,
      timeout => timeout
      );


  mclk <= not mclk after half_period;


  process
  begin
    breq <= "100";
    rst <= '1';
    timeout <= '0';
    wait for 40 ns;
    rst <= '0';
    wait for 40 ns;
    breq <= "001", "110" after 60 ns;
    wait for 80;
    timeout <= '1';
    wait for 40 ns;
    timeout <= '1';
    breq <= "111";
    wait;



  end process;
end architecture testbench;
