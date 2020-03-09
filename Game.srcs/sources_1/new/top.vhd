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

component VGA is
    Port ( Pixel_clk : in STD_LOGIC;
           reset : in STD_LOGIC;
                       
           --output sync and clour
           hsync, vsync : out  STD_LOGIC;	
           r_out:  OUT  STD_LOGIC_VECTOR(3 DOWNTO 0);
           g_out:  OUT  STD_LOGIC_VECTOR(3 DOWNTO 0);
           b_out:  OUT  STD_LOGIC_VECTOR(3 DOWNTO 0));
           
           --LED  : out STD_LOGIC_VECTOR (7 downto 0) := x"FF");
end component;

signal clk_out : STD_LOGIC;
signal clk_pixel : STD_LOGIC;

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
           
vga_layout : VGA port map( 
           Pixel_clk => clk_pixel,
           reset => reset,
            
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
