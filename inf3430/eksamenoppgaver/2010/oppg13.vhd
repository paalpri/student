use IEEE.numeric_std.all;
use work.code_lock_pkg.all;
entity code_sreg is
  port
    (
      reset : in std_logic;
      clk : in std_logic;
      shift_code : in std_logic;
      code_in : in std_logic_vector(3 downto 0);
      code_out : out code_type
      );
end ;
architecture rtl of code_sreg is

  type code_type is array (0 to 2) of unsigned(3 downto 0);


  process
    if(reset = '1') then
      code_type(0) <= (others => '0');
      code_type(1) <= (others => '0');
      code_type(2) <= (others => '0');
    elsif(rising_edge(clk)) then
      if(shift_reg = '1') then
        code_type(2) <= code_type(1);
        code_type(1) <= code_type(0);
        code_type(0) <=unsigned (code_in);
      end if;
    end if;
  end process;
  code_out <= code_i;
end architecture rtl;




library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use work.code_lock_pkg.all;

entity codelock is
 port
 (
 reset : in std_logic;
 clk : in std_logic;
 code_in : in std_logic_vector(3 downto 0);
 entered : in std_logic;
 door : in std_logic;
 open_door : out std_logic;
 close_door: out std_logic;
 error : out std_logic;
 alarm : out std_logic
 );
end codelock;

architecture rtl of codelock is

  type state is : (idle_st,close_0_st,close_st,open_0_st,open_st,alarm_st);
  signal curr_st,next_st;
  
  signal code_mid : code_type;
  signal count : unsigned(1 downto 0);
  signal failcnt : unsigned(3 downto 0);
  signal shift_code : std_logic;
  signal code : code_type;

component code_sreg is
  port
    (
      reset : in std_logic;
      clk : in std_logic;
      shift_code : in std_logic;
      code_in : in std_logic_vector(3 downto 0);
      code_out : out code_type
      );
end component;
begin
  
  code_mitt_eget_navn_stuff: code_sreg
  port map
    (
      reset => reset,
      clk => clk,
        shift_code =>shift_code,
      code_in => code_in,
      code_out => code
      );



  process(clk,reset)
    if(reset = '1') then
      error <= '0';
      failcnt <= '0';
      count <= '0';
    elsif(rising_edge(clk)) then
      curr_st <= next_st;
    end if
  end process

      process(curr_st,entered)

        case curr_st is
          when idle_st =>
            if(entered = '1') then
              shift_code <= '1';
              next_st <= close_0_st;
            else
              next_st <= idle_st;
            end if
              when close_0_st =>
            if(entered = '0') then
              next_st <= close_0_st;
            else
              count <= count + '1';
              shift_code <= '1';
              if(count = '3') then
                next_st <= close_st;
              else
                next_st <= close_0_st;
              end if;
            end if;
          when close_st =>
            if(door = '1') then
              close_door <= '1';
              next_st <= open_0_st;
              count <= '0';
            end if;
            when open_0_st;
            if(entered = '1') then
              code_mid(count) <= code_in;
              count <= count + '1';
              if(count = '3') then
                next_st <= open_st;
              end if;
            end if;
          when open_st =>
            if(code_mid = code) then
              open_door <= '1';
              next_st <= idle_st;
            else
              if(failcnt < 10) then
                failcnt <= failcnt + '1';
                error <= '1';
                next_st <= open_0_st;
              else
                alarm <= '1';
                next_st <= alarm_st;
              end if;
            end if;
        end case;
      end process;
      end architecture;
            
