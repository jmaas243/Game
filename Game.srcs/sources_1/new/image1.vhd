----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 03/01/2020 07:38:10 PM
-- Design Name: 
-- Module Name: image1 - Behavioral
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

use IEEE.NUMERIC_STD.ALL;

use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

--use ieee.std_logic_unsigned.all;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity screen_writer is
    Port ( clk : in STD_LOGIC;
           reset : in STD_LOGIC;

           hcount, vcount : IN    INTEGER;	
           
           r_out:  OUT  STD_LOGIC_VECTOR(3 DOWNTO 0);
           g_out:  OUT  STD_LOGIC_VECTOR(3 DOWNTO 0);
           b_out:  OUT  STD_LOGIC_VECTOR(3 DOWNTO 0);
           LED : OUT  STD_LOGIC_VECTOR(7 DOWNTO 0)
           );
end screen_writer;

architecture Behavioral of screen_writer is
--constant H_pixels: integer := 640;
--constant V_pixels: integer := 480;

constant W : integer := 16;
constant H : integer := 16;

signal x, y : INTEGER;
signal xdir, ydir : std_logic;

constant Scale : integer := 2; --mutiply pixels horizontal and vertical

Component block_coe IS
  PORT (
    clka : IN STD_LOGIC;
    ena : IN STD_LOGIC;
    wea : IN STD_LOGIC_VECTOR(0 DOWNTO 0);
    addra : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
    dina : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
    douta : OUT STD_LOGIC_VECTOR(3 DOWNTO 0)
  );
END component;

Component wall_coe IS
  PORT (
    clka : IN STD_LOGIC;
    ena : IN STD_LOGIC;
    wea : IN STD_LOGIC_VECTOR(0 DOWNTO 0);
    addra : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
    dina : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
    douta : OUT STD_LOGIC_VECTOR(3 DOWNTO 0)
  );
END component;

Component color_scheme is
    Port ( 
    Data_In : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
    R_Data_Out : OUT STD_LOGIC_VECTOR(3 DOWNTO 0);
    G_Data_Out : OUT STD_LOGIC_VECTOR(3 DOWNTO 0);
    B_Data_Out : OUT STD_LOGIC_VECTOR(3 DOWNTO 0)
    );
end component;

signal ena : std_logic := '1';
signal wea : std_logic_VECTOR(0 downto 0):="0";

signal din_block,dout_block : std_logic_VECTOR(3 downto 0) := (others => '0');
signal addra : std_logic_VECTOR(7 downto 0) := (others => '0');

signal din_wall,dout_wall : std_logic_VECTOR(3 downto 0) := (others => '0');
signal addr_wall : std_logic_VECTOR(7 downto 0) := (others => '0');

signal hor_int : INTEGER;
signal ver_int : INTEGER;

signal read_block : INTEGER;
signal read_wall : INTEGER;

signal Data_In, R_Data_Out, G_Data_Out, B_Data_Out : std_logic_VECTOR(3 downto 0);

begin

block_ram: block_coe port map(
           clka => clk,  --clock for writing data to RAM.
           ena => ena,   --Enable signal.
           wea => wea,   --Write enable signal for Port A.
           addra => addra, 
           dina => din_block, 
           douta => dout_block);
           
wall_ram: wall_coe port map(
           clka => clk,  --clock for writing data to RAM.
           ena => ena,   --Enable signal.
           wea => wea,   --Write enable signal for Port A.
           addra => addr_wall, 
           dina => din_wall, 
           douta => dout_wall);    
           
color_scheme_layout: color_scheme port map(
           Data_In => Data_In,
           R_Data_Out => R_Data_Out,
           G_Data_Out => G_Data_Out,
           B_Data_Out => B_Data_Out);  

process(reset)

begin
if (reset = '1') then
--    x <= 5;
--    y <= 5;  
    hor_int <= (((hcount+2)/Scale) mod W);
   ver_int <= ((vcount/Scale) mod H);

else
   hor_int <= ((hcount+2/Scale) mod W);
   ver_int <= ((vcount/Scale) mod H);
end if; 

read_wall <= ((hor_int+(ver_int*16))+1);        --without offset
        
-- Als er geldige data in de sprite staat  
   if (vcount >= 3*Scale*H and vcount < 4*Scale*H) then 
   
   addr_wall <= std_logic_vector(to_unsigned(read_wall, addr_wall'length));
   Data_In <= dout_wall;
                               
   r_out <= R_Data_Out;         
   g_out <= G_Data_Out;
   b_out <= B_Data_Out;   
   
   elsif (vcount >= ((9*Scale*H)) and vcount < ((10*Scale*H)) and hcount >= ((9*Scale*W)) and hcount < ((10*Scale*W))) then
   r_out <= x"F";         
   g_out <= x"0";
   b_out <= x"0";   
    
-- Anders achtergrond schrijven
    else    --gray header
        if (vcount >= 0 and vcount < 2*Scale*H) then
        r_out <= x"2";         
        g_out <= x"2";
        b_out <= x"2";   
       
        elsif          -- green grass
        
        (
        (vcount >= 3*Scale*H and vcount < 4*Scale*H) or
        (vcount >= 5*Scale*H and vcount < 6*Scale*H) or
        (vcount >= 7*Scale*H and vcount < 8*Scale*H) or
        (vcount >= 9*Scale*H and vcount < 10*Scale*H) or
        (vcount >= 11*Scale*H and vcount < 12*Scale*H) or
        (vcount >= 13*Scale*H and vcount < 14*Scale*H) or
    
        (hcount >= 1*Scale*W and hcount < 2*Scale*W) or
        (hcount >= 3*Scale*W and hcount < 4*Scale*W) or
        (hcount >= 5*Scale*W and hcount < 6*Scale*W) or
        (hcount >= 7*Scale*W and hcount < 8*Scale*W) or
        (hcount >= 9*Scale*W and hcount < 10*Scale*W) or
        (hcount >= 11*Scale*W and hcount < 12*Scale*W) or
        (hcount >= 13*Scale*W and hcount < 14*Scale*W) or
        (hcount >= 15*Scale*W and hcount < 16*Scale*W) or
        (hcount >= 17*Scale*W and hcount < 18*Scale*W) or
        (hcount >= 19*Scale*W and hcount < 20*Scale*W)  
        ) 
        
        and 
        (vcount >= 3*Scale*H and vcount < 14*Scale*H)
    
        then  
            r_out <= x"0";              
            g_out <= x"2";
            b_out <= x"0";
              
--als er geen gras is moet er een muur zijn  
        else
            read_block <= ((hor_int+(ver_int*16)));        --without offset     
            
            addra <= std_logic_vector(to_unsigned(read_block, addra'length));
            Data_In <= dout_block;
                               
            r_out <= R_Data_Out;         
            g_out <= G_Data_Out;
            b_out <= B_Data_Out;
    
        end if;  --background  
    end if; --sprite
   
end process;

end Behavioral;