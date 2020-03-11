----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 03/01/2020 06:14:43 PM
-- Design Name: 
-- Module Name: top - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity top is
Port(
clk : in STD_LOGIC;
reset : in STD_LOGIC;

spi_clk : in STD_LOGIC;
miso : out STD_LOGIC;
mosi : in STD_LOGIC;
slaveselect : in STD_LOGIC;

--output sync and clour
hsync, vsync : out  STD_LOGIC;	
r_out:  OUT  STD_LOGIC_VECTOR(3 DOWNTO 0);
g_out:  OUT  STD_LOGIC_VECTOR(3 DOWNTO 0);
b_out:  OUT  STD_LOGIC_VECTOR(3 DOWNTO 0);

--buffer input from SPI
LED : OUT STD_LOGIC_VECTOR (7 downto 0)); 
end top;

architecture Behavioral of top is

Component clk_wiz is
  Port ( 
    clk_out : out STD_LOGIC;
    clk_pixel : out STD_LOGIC;
    clk_in : in STD_LOGIC);
 end component;
 
component spi is
    Port ( SCK  : in  STD_LOGIC;    -- SPI input clock
           MISO : out STD_LOGIC;    -- SPI serial data output
           MOSI : in  STD_LOGIC;    -- SPI serial data input
           SS   : in  STD_LOGIC;    -- chip select input (active low)
           LED  : out STD_LOGIC_VECTOR (7 downto 0) := x"FF");
end component;

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

component VGA is
    Port (           
          Pixel_clk : in STD_LOGIC;
          Reset : in STD_LOGIC;
          
          r_in:  IN  STD_LOGIC_VECTOR(3 DOWNTO 0);
          g_in:  IN  STD_LOGIC_VECTOR(3 DOWNTO 0);
          b_in:  IN  STD_LOGIC_VECTOR(3 DOWNTO 0);
          
          HPos     : out integer;
          VPos     : out integer;
          --output sync and clour
          hsync, vsync : out  STD_LOGIC;	
          r_out:  OUT  STD_LOGIC_VECTOR(3 DOWNTO 0);
          g_out:  OUT  STD_LOGIC_VECTOR(3 DOWNTO 0);
          b_out:  OUT  STD_LOGIC_VECTOR(3 DOWNTO 0));
           
           --LED  : out STD_LOGIC_VECTOR (7 downto 0) := x"FF");
end component;

--clock 100
signal clk_out : STD_LOGIC;

--vga clock 25
signal clk_pixel : STD_LOGIC;
signal s_Hpos,s_Vpos : integer := 0;

--sprite writer
signal s_R, s_G, s_B : std_logic_vector(3 downto 0);

--led debug
signal led_zero : STD_LOGIC_VECTOR(7 downto 0);

begin

clock_layout : clk_wiz port map(
           clk_in => clk,
           clk_pixel => clk_pixel,
           clk_out => clk_out);

spi_layout : spi port map( 
           SCK => spi_clk,
           MISO => miso,
           MOSI => mosi,
           SS => slaveselect,
           LED => LED(7 downto 0));
           
screen_writer_layout : screen_writer port map(
           clk => clk_pixel,
           reset => reset,
           
           hcount => s_Hpos, 
           vcount => s_Vpos,
           
           r_out =>  s_R,
           g_out =>  s_G,
           b_out =>  s_B
           
           --LED => LED
           );               
           
vga_layout : VGA port map( 


           Pixel_clk => clk_pixel,
           reset => reset,
            
            r_in => s_R,
            g_in => s_G,
            b_in => s_B,
          
            HPos     => s_Hpos,
            VPos     => s_Vpos,
          
           --output sync and clour
           hsync => hsync, 
           vsync => vsync,
           
           r_out =>  r_out(3 DOWNTO 0),
           g_out =>  g_out(3 DOWNTO 0),
           b_out =>  b_out(3 DOWNTO 0));
           --LED => LED(7 downto 0));
                  

--process(reset)
--begin
--    if (reset = '1') then
        
--    elsif (rising_edge(clk)) then
       
--    end if;
    
--end process;

end Behavioral;
