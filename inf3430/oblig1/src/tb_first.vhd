library IEEE;
use IEEE.Std_Logic_1164.all;

entity TEST_FIRST is
  -- The entity for a testbench is normally empty
end TEST_FIRST;

architecture TESTBENCH of TEST_FIRST is
  
  -- Component declarations
  Component FIRST 
    port
    (
      CLK        : in  std_logic; -- Clock from switch CLK1/INP1
      RESET      : in  std_logic; -- Global Asynchronous Reset
      LOAD       : in  std_logic; -- Synchronous Reset
      INP        : in  std_logic_vector(3 downto 0); -- Start Value
      COUNT      : out std_logic_vector(3 downto 0); -- Counting value
      MAX_COUNT  : out std_logic  -- Max counting value 
    );
  end Component;
  
  --testbench internal signals
  --which should be used to connect with the component first
  --input to UUT should be given initial values
  signal  MCLK        : std_logic := '0'; --:= initial value
  signal  RESET      : std_logic := '0';
  signal  LOAD       : std_logic := '0';
  signal  INP        : std_logic_vector(3 downto 0) := "0000";
  signal  COUNT      : std_logic_vector(3 downto 0);
  signal  MAX_COUNT  : std_logic;
  
  constant Half_Period : time := 10 ns;  --50Mhz klokkefrekvens
  
begin
  
  --Instantiates "Unit Under Test", UUT
  UUT : FIRST
  port map
  ( 
  --<formal name> => <actual name> 
    CLK        =>  MCLK,       
    RESET      =>  RESET,  
    LOAD       =>  LOAD,      
    INP        =>  INP,       
    COUNT      =>  COUNT,     
    MAX_COUNT  =>  MAX_COUNT
  );
  
  -- Defines the clock
  MCLK <= not MCLK after Half_Period;
  
  -- The input stimuli to UUT
  STIMULI :
  process
  --a process with an empty sensitivity list should include wait statements
  begin
    RESET <= '1', '0' after 100 ns;
    INP <= "1010" after Half_Period*6;
    wait for 2*Half_Period*10;
    LOAD <= '1', '0' after 2*Half_Period;
    wait; 
  end process;           
  
end TESTBENCH;
