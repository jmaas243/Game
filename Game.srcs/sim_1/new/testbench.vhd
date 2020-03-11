library ieee;
use ieee.std_logic_1164.all;

entity tb is
end entity;

architecture sim of tb is

component screen_writer
		port(
           clk : in STD_LOGIC;
           reset : in STD_LOGIC;
           
           hcount, vcount : IN    INTEGER;	
           
           r_out:  OUT  STD_LOGIC_VECTOR(3 DOWNTO 0);
           g_out:  OUT  STD_LOGIC_VECTOR(3 DOWNTO 0);
           b_out:  OUT  STD_LOGIC_VECTOR(3 DOWNTO 0)
--           LED: OUT  STD_LOGIC_VECTOR(7 DOWNTO 0)
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
    signal s_R, s_G, s_B : std_logic_vector(3 downto 0);
    
   signal test_h,test_h2, test_h3 : integer := 0;
   signal test_v,read_wall : integer := 0;
begin

screen_writer_layout : screen_writer port map(
           clk => clk_25,
           reset => reset,
           
           hcount => s_Hpos, 
           vcount => s_Vpos,
           
           r_out =>  s_R,
           g_out =>  s_G,
           b_out =>  s_B
           
           --LED => LED
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

    test_h <= ((s_Hpos/2) mod 16);
    test_h2 <= (((s_Hpos-2)/2) mod 16)+1;
    test_h3 <= (((s_Hpos-1)/2) mod 16)+1;
    
    test_v <= (((s_Vpos-1)/2) mod 16);
    read_wall <= ((test_h3+(test_v*16))); --crashes after ver_int
  -- Time resolution show
  assert FALSE report "Time resolution: " & time'image(time'succ(0 fs)) severity NOTE;

end architecture;