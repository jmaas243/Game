library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use IEEE.NUMERIC_STD.ALL;

entity VGA is
    Port (    Pixel_clk : in STD_LOGIC;
              reset : in STD_LOGIC;
    
              --output sync and clour
              hsync, vsync : out  STD_LOGIC;	
              r_out:  OUT  STD_LOGIC_VECTOR(3 DOWNTO 0);
              g_out:  OUT  STD_LOGIC_VECTOR(3 DOWNTO 0);
              b_out:  OUT  STD_LOGIC_VECTOR(3 DOWNTO 0));
              
              --LED  : out STD_LOGIC_VECTOR (7 downto 0) := x"FF");
                         		  
end VGA;

architecture Behavioral of VGA is 
  constant H_pixels: integer := 640;			--horizontal display width in pixels
  constant H_frontporch: integer := 16;			--horizontal front porch width in pixels
  constant H_syncwidth: integer := 96; 			--horizontal sync pulse width in pixels
  constant H_backporch: integer := 48;			--horizontal back porch width in pixels
  constant H_total_pixels: integer := (H_pixels + H_frontporch + H_syncwidth + H_backporch);
  constant H_sync_polarity: STD_LOGIC := '0';	--horizontal sync pulse polarity (1 = positive, 0 = negative)
  constant V_pixels: integer := 480;			--vertical display width in rows
  constant V_frontporch: integer := 10;			--vertical front porch width in rows
  constant V_syncwidth: integer := 2;			--vertical sync pulse width in rows
  constant V_backporch: integer := 33;			--vertical back porch width in rows
  constant V_total_pixels: integer := (V_pixels + V_frontporch + V_syncwidth + V_backporch);
  constant V_sync_polarity: STD_LOGIC := '0';	--vertical sync pulse polarity (1 = positive, 0 = negative)

component screen_writer is
    Port (
           clk : in STD_LOGIC;
           reset : in STD_LOGIC;
           
           hcount, vcount : IN    INTEGER;	
           r_out:  OUT  STD_LOGIC_VECTOR(3 DOWNTO 0);
           g_out:  OUT  STD_LOGIC_VECTOR(3 DOWNTO 0);
           b_out:  OUT  STD_LOGIC_VECTOR(3 DOWNTO 0)
--           LED: OUT  STD_LOGIC_VECTOR(7 DOWNTO 0)
           );
end component;

--vga position and colour input
signal x: INTEGER;
signal y: INTEGER;

signal r_in, g_in, b_in : STD_LOGIC_VECTOR(3 downto 0); 
  
begin

           
screen_writer_layout : screen_writer port map(
           clk => Pixel_clk,
           reset => reset,
           
           hcount => x, 
           vcount => y,
           r_out =>  r_in(3 DOWNTO 0),
           g_out =>  g_in(3 DOWNTO 0),
           b_out =>  b_in(3 DOWNTO 0)
           
           --LED => LED
           );    

process (Pixel_clk) 
    VARIABLE hcount	:	INTEGER RANGE 0 TO H_total_pixels - 1 := 0;  --horizontal counter (counts the columns)
	VARIABLE vcount	:	INTEGER RANGE 0 TO V_total_pixels - 1 := 0;  --vertical counter (counts the rows)
begin
  if rising_edge(Pixel_clk) then
	   -- display time
	   if (hcount >= 0) and (hcount < H_pixels) and (vcount >= 0) and (vcount < V_pixels) then	
        r_out <=  r_in(3 DOWNTO 0);
        g_out <=  g_in(3 DOWNTO 0);
        b_out <=  b_in(3 DOWNTO 0); 
      -- blanking time
	  else 
        r_out <= "0000";
        g_out <= "0000";
        b_out <= "0000"; 
      end if;
	  -- Horizontal sync pulse signal
      if ((hcount >= (H_pixels + H_frontporch)) and (hcount < (H_pixels + H_frontporch + H_syncwidth))) then
        hsync <= H_sync_polarity;
      else
        hsync <= (not H_sync_polarity);
      end if;
	  -- vertical sync pulse signal
      if ((vcount >= (V_pixels + V_frontporch)) and (vcount < (V_pixels + V_frontporch + V_syncwidth))) then
        vsync <= V_sync_polarity;
      else
        vsync <= (not V_sync_polarity);
      end if;
	  -- horizontal pixel counter
      hcount := hcount + 1;
	 
      if hcount = (H_total_pixels - 1) then
	  -- vertical line counter
        vcount := vcount + 1;
        hcount := 0;
      end if;
	 
      if vcount = (V_total_pixels -1) then		    
        vcount := 0;
      end if;
      
      x <= hcount;
      y <= vcount;
	 end if;
end process;

end Behavioral;
