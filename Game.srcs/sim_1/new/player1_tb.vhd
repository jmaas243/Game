library ieee;
use ieee.std_logic_1164.all;
library UNISIM; 
use UNISIM.Vcomponents.all;

entity player1_tb is
end entity;

architecture sim of player1_tb is

component player1 IS
    generic(
        g_HINIT   : integer := 200;
        g_VINIT   : integer := 140;
        g_HCORNER : integer := 360;
        g_VCORNER : integer := 340
    );
    Port(
        p_Clock     : in  std_logic;
        p_Reset     : in  std_logic;
        p_HPos      : in  integer range 0 to 65535;
        p_VPos      : in  integer range 0 to 65535;
        Data_Out : OUT STD_LOGIC_VECTOR(3 DOWNTO 0)
    );
end component;

  -- Procedure for clock generation
  procedure clk_gen(signal clk : out std_logic; constant FREQ : real) is
    constant PERIOD    : time := 1 sec / FREQ;        -- Full period
    constant HIGH_TIME : time := PERIOD / 2;          -- High time
    constant LOW_TIME  : time := PERIOD - HIGH_TIME;  -- Low time; always >= HIGH_TIME
  begin
    -- Check the arguments
    assert (HIGH_TIME /= 0 fs) report "clk_plain: High time is zero; time resolution to large for frequency" severity FAILURE;
    -- Generate a clock cycle
    loop
      clk <= '1';
      wait for HIGH_TIME;
      clk <= '0';
      wait for LOW_TIME;
    end loop;
  end procedure;

  -- Clock frequency and signal
  signal clk_25 : std_logic;
  signal reset : std_logic;
  signal s_Hpos,s_Vpos : integer := 0;
   signal s_Data_Out : std_logic_vector(3 downto 0) := (others => '0');
   signal test_h3 : integer := 0;
   signal test_v,read : integer := 0;
   

   
begin


Bomberman1 : player1
    generic map(
        g_HINIT   => 120,
        g_VINIT   => 40,
        g_HCORNER => 440,
        g_VCORNER => 140
    )
    Port map(
        p_Clock     => clk_25,
        p_Reset     => reset,
        p_HPos      => s_Hpos,
        p_VPos      => s_Vpos,
        
        Data_Out => s_Data_Out
    );
           
  -- Clock generation with concurrent procedure call
  clk_gen(clk_25, 25.175E6);  -- 166.667 MHz clock

process(clk_25)
begin
    if (rising_edge(clk_25)) then
    s_Hpos <= s_Hpos+1;
    
    if(s_Hpos = 640) then
    s_Hpos <= 0;
    s_Vpos <= s_Vpos+1;
    end if;
    
    if(s_Vpos = 480) then
    s_Vpos <= 0;
    end if;
    
    end if;
end process;
    
    test_h3 <= (((s_Hpos-1)/2) mod 16)+1;
    
    test_v <= (((s_Vpos-1)/2) mod 16);
    read <= ((test_h3+(test_v*16))); --crashes after ver_int

    
  -- Time resolution show
  --assert FALSE report "Time resolution: " & time'image(time'succ(0 fs)) severity NOTE;

end architecture;