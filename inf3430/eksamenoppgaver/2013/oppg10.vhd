library ieee;
use  ieee.std_logic_1116.all;
use  ieee.numeric_std.all;

entity arbiter is
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
end entity arbiter;

  type state_type is (WAIT_BREQ0_ST,WAIT_BREQ1_ST,WAIT_BREQ2_ST,BGRANT0_ST,BGRANT1_ST,BGRANT2_ST,BTOUT0_ST,BTOUT1_ST,BTOUT2_ST);
  signal PRESENT_STATE, NEXT_STATE : state_type;

  architecture rtl of arbiter is
  begin
    process(clk,rst) is
      if(rst = '1') then
        NEXT_STATE <= WAIT_BREQ2_ST;
        timer_rst <= '1';
      elsif(rising_edge(clk)) then
        PRESENT_STATE <= NEXT_STATE;
      end if;
    end process;

    process(PRESENT_STATE,clk,rst)
      bgrant(0) <= '0';
      bgrant(1) <= '0';
      bgrant(1) <= '0';
      timer_en <= '1';

      case PRESENT_STATE is
        when  WAIT_BREQ2_ST =>
          if(breq(0) = '1') then
            NEXT_STATE <= BGRANT0_ST;
          elsif(breq(1) = '1') then
            NEXT_STATE <= BGRANT1_ST;
          elsif breq(2) = '1' then
            NEXT_STATE <= BGRANT2_ST;
          else;
              WAIT_BREQ0_ST;
          end if;

        when WAIT_BREQ1_ST =>
          if(breq(1) = '1') then
            NEXT_STATE <= BGRANT1_ST;
          elsif(breq(2) = '1') then
            NEXT_STATE <= BGRANT2_ST;
          elsif breq(0) = '1' then
            NEXT_STATE <= BGRANT0_ST;
          else;
              WAIT_BREQ0_ST;
          end if;

        when WAIT_BREQ2_ST =>
          if(breq(2) = '1') then
            NEXT_STATE <= BGRANT2_ST;
          elsif(breq(0) = '1') then
            NEXT_STATE <= BGRANT0_ST;
          elsif breq(1) = '1' then
            NEXT_STATE <= BGRANT1_ST;
          else;
              WAIT_BREQ0_ST;
          end if;

        when BGRANT0_ST =>
          btout(0) <= '0';
          bgrant(0) <= '1';
          timer_en <= '1';
          if(breq(0) = '0') then
            NEXT_STATE <= WAIT_BREQ1_ST;
          elsif timeout = '1' then
            NEXT_STATE <= BTOUT0_ST;
          else
            NEXT_STATE <= BGRANT0_ST;
          end if;

        when BGRANT1_ST =>
          btout(1) <= '0';
          bgrant(1) <= '1';
          timer_en <= '1';
          if(breq(1) = '0') then
            NEXT_STATE <= WAIT_BREQ2_ST;
          elsif timeout = '1' then
            NEXT_STATE <= BTOUT1_ST;
          else
            NEXT_STATE <= BGRANT1_ST;
          end if;

        when BGRANT2_ST =>
          btout(2) <= '0';
          bgrant(2) <= '1';
          timer_en <= '1';
          if(breq(2) = '0') then
            NEXT_STATE <= WAIT_BREQ0_ST;
          elsif timeout = '1' then
            NEXT_STATE <= BTOUT2_ST;
          else
            NEXT_STATE <= BGRANT2_ST;
          end if;

        when others =>
          NEXT_STATE <= WAIT_BREQ0_ST;
      end case;
