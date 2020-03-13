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

COMPONENT bomb_coe
    Port(
        clka : IN STD_LOGIC;
        ena : IN STD_LOGIC;
        wea : IN STD_LOGIC_VECTOR(0 DOWNTO 0);
        addra : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
        dina : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
        douta : OUT STD_LOGIC_VECTOR(3 DOWNTO 0)
    );
END COMPONENT;

COMPONENT bomb_up_coe
    Port(
        clka : IN STD_LOGIC;
        ena : IN STD_LOGIC;
        wea : IN STD_LOGIC_VECTOR(0 DOWNTO 0);
        addra : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
        dina : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
        douta : OUT STD_LOGIC_VECTOR(3 DOWNTO 0)
    );
END COMPONENT;

COMPONENT freeze_coe
    Port(
        clka : IN STD_LOGIC;
        ena : IN STD_LOGIC;
        wea : IN STD_LOGIC_VECTOR(0 DOWNTO 0);
        addra : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
        dina : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
        douta : OUT STD_LOGIC_VECTOR(3 DOWNTO 0)
    );
END COMPONENT;

COMPONENT speed_coe
    Port(
        clka : IN STD_LOGIC;
        ena : IN STD_LOGIC;
        wea : IN STD_LOGIC_VECTOR(0 DOWNTO 0);
        addra : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
        dina : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
        douta : OUT STD_LOGIC_VECTOR(3 DOWNTO 0)
    );
END COMPONENT;

COMPONENT player1_coe
    Port(
        clka : IN STD_LOGIC;
        ena : IN STD_LOGIC;
        wea : IN STD_LOGIC_VECTOR(0 DOWNTO 0);
        addra : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
        dina : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
        douta : OUT STD_LOGIC_VECTOR(3 DOWNTO 0)
    );
END COMPONENT;

COMPONENT player2_coe
    Port(
        clka : IN STD_LOGIC;
        ena : IN STD_LOGIC;
        wea : IN STD_LOGIC_VECTOR(0 DOWNTO 0);
        addra : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
        dina : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
        douta : OUT STD_LOGIC_VECTOR(3 DOWNTO 0)
    );
END COMPONENT;
	
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

COMPONENT heart_coe
    Port(
        clka : IN STD_LOGIC;
        ena : IN STD_LOGIC;
        wea : IN STD_LOGIC_VECTOR(0 DOWNTO 0);
        addra : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
        dina : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
        douta : OUT STD_LOGIC_VECTOR(3 DOWNTO 0)
    );
END COMPONENT;

Component color_scheme is
    Port ( 
    Data_In : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
    R_Data_Out : OUT STD_LOGIC_VECTOR(3 DOWNTO 0);
    G_Data_Out : OUT STD_LOGIC_VECTOR(3 DOWNTO 0);
    B_Data_Out : OUT STD_LOGIC_VECTOR(3 DOWNTO 0)
    );
end component;

--for al block rams
signal ena : std_logic := '1';
signal wea : std_logic_VECTOR(0 downto 0):="0";

--heart
signal din_heart,dout_heart : std_logic_VECTOR(3 downto 0) := (others => '0');
signal addr_heart : std_logic_VECTOR(7 downto 0) := (others => '0');
signal read_heart : INTEGER;

--block
signal din_block,dout_block : std_logic_VECTOR(3 downto 0) := (others => '0');
signal addr_block : std_logic_VECTOR(7 downto 0) := (others => '0');
signal read_block : INTEGER;

--wall
signal din_wall,dout_wall : std_logic_VECTOR(3 downto 0) := (others => '0');
signal addr_wall : std_logic_VECTOR(7 downto 0) := (others => '0');
signal read_wall : INTEGER;

--player1
signal din_player1,dout_player1 : std_logic_VECTOR(3 downto 0) := (others => '0');
signal addr_player1 : std_logic_VECTOR(7 downto 0) := (others => '0');
signal read_player1 : INTEGER;

--player2
signal din_player2,dout_player2 : std_logic_VECTOR(3 downto 0) := (others => '0');
signal addr_player2 : std_logic_VECTOR(7 downto 0) := (others => '0');
signal read_player2 : INTEGER;

--speed
signal din_speed,dout_speed : std_logic_VECTOR(3 downto 0) := (others => '0');
signal addr_speed : std_logic_VECTOR(7 downto 0) := (others => '0');
signal read_speed : INTEGER;

--bomb
signal din_bomb,dout_bomb : std_logic_VECTOR(3 downto 0) := (others => '0');
signal addr_bomb : std_logic_VECTOR(7 downto 0) := (others => '0');
signal read_bomb : INTEGER;

--bomb_up
signal din_bomb_up,dout_bomb_up : std_logic_VECTOR(3 downto 0) := (others => '0');
signal addr_bomb_up : std_logic_VECTOR(7 downto 0) := (others => '0');
signal read_bomb_up : INTEGER;

--freeze
signal din_freeze,dout_freeze : std_logic_VECTOR(3 downto 0) := (others => '0');
signal addr_freeze : std_logic_VECTOR(7 downto 0) := (others => '0');
signal read_freeze : INTEGER;

--calculate current position in block ram
signal hor_int, ver_int : INTEGER;

--check for transparent
signal enable_player1 : STD_LOGIC;
signal enable_player2 : STD_LOGIC;
signal enable_bomb    : STD_LOGIC;

--color pallete
signal Data_In, R_Data_Out, G_Data_Out, B_Data_Out : std_logic_VECTOR(3 downto 0);

begin

bomb_ram: bomb_coe port map(
           clka => clk,  --clock for writing data to RAM.
           ena => ena,   --Enable signal.
           wea => wea,   --Write enable signal for Port A.
           addra => addr_bomb, 
           dina => din_bomb, 
           douta => dout_bomb);
           
bomb_up_ram: bomb_up_coe port map(
           clka => clk,  --clock for writing data to RAM.
           ena => ena,   --Enable signal.
           wea => wea,   --Write enable signal for Port A.
           addra => addr_bomb_up, 
           dina => din_bomb_up, 
           douta => dout_bomb_up);
           
freeze_ram: freeze_coe port map(
           clka => clk,  --clock for writing data to RAM.
           ena => ena,   --Enable signal.
           wea => wea,   --Write enable signal for Port A.
           addra => addr_freeze, 
           dina => din_freeze, 
           douta => dout_freeze);
           
heart_ram: heart_coe port map(
           clka => clk,  --clock for writing data to RAM.
           ena => ena,   --Enable signal.
           wea => wea,   --Write enable signal for Port A.
           addra => addr_heart, 
           dina => din_heart, 
           douta => dout_heart);
           
speed_ram: speed_coe port map(
           clka => clk,  --clock for writing data to RAM.
           ena => ena,   --Enable signal.
           wea => wea,   --Write enable signal for Port A.
           addra => addr_speed, 
           dina => din_speed, 
           douta => dout_speed);
           
player1_ram: player1_coe port map(
           clka => clk,  --clock for writing data to RAM.
           ena => ena,   --Enable signal.
           wea => wea,   --Write enable signal for Port A.
           addra => addr_player1, 
           dina => din_player1, 
           douta => dout_player1);
           
player2_ram: player2_coe port map(
           clka => clk,  --clock for writing data to RAM.
           ena => ena,   --Enable signal.
           wea => wea,   --Write enable signal for Port A.
           addra => addr_player2, 
           dina => din_player2, 
           douta => dout_player2);
           
block_ram: block_coe port map(
           clka => clk,  --clock for writing data to RAM.
           ena => ena,   --Enable signal.
           wea => wea,   --Write enable signal for Port A.
           addra => addr_block, 
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
--variable hor_int : INTEGER;
--variable ver_int : INTEGER;

begin
if (reset = '1') then
x <= 0;
y <= 0;  
else               
        x<= 200;
        y<= 64;      
end if;

       hor_int <= ((((hcount-1)/2) mod 16)+1);
       ver_int <= ((((vcount-1)/Scale) mod H)); 
       
        --get current data wall
        read_wall <= ((hor_int+(ver_int*16)));   
        addr_wall <= std_logic_vector(to_unsigned(read_wall, addr_wall'length));
        
        --get current date bomb
        read_bomb <= ((hor_int+(ver_int*16)));            
        addr_bomb <= std_logic_vector(to_unsigned(read_bomb, addr_bomb'length));
         
        --get current date block 
        read_block <= ((hor_int+(ver_int*16)));            
        addr_block <= std_logic_vector(to_unsigned(read_block, addr_block'length));
        
        --get current date player1
        read_player1 <= (((((((hcount-1)/2)+x) mod 16)+1)+((((((vcount-1)/Scale)+y) mod H))*16)));             
        addr_player1 <= std_logic_vector(to_unsigned(read_player1, addr_player1'length));        
        
        --get current date player2
        read_player2 <= ((hor_int+(ver_int*16)));            
        addr_player2 <= std_logic_vector(to_unsigned(read_player2, addr_player2'length));
        
        --get current date speed
        read_speed <= (((((((hcount-1)/2)+0) mod 16)+1)+((((((vcount-1)/Scale)+24) mod H))*16)));             
        addr_speed <= std_logic_vector(to_unsigned(read_speed, addr_speed'length));
        
        --get current date bomb_up
        read_bomb_up <= (((((((hcount-1)/2)+0) mod 16)+1)+((((((vcount-1)/Scale)+24) mod H))*16)));            
        addr_bomb_up <= std_logic_vector(to_unsigned(read_bomb_up, addr_bomb_up'length));
         
        --get current date freeze
        read_freeze <= (((((((hcount-1)/2)+0) mod 16)+1)+((((((vcount-1)/Scale)+24) mod H))*16)));            
        addr_freeze <= std_logic_vector(to_unsigned(read_freeze, addr_freeze'length)); 
              
        --get current date heart
        read_heart <= (((((((hcount-1)/2)+0) mod 16)+1)+((((((vcount-1)/Scale)+24) mod H))*16)));            
        addr_heart <= std_logic_vector(to_unsigned(read_heart, addr_heart'length));
            
        if (dout_player1 = 9) then
            enable_player1 <= '0';
            else
         enable_player1 <= '1';
        end if;   
        
        if (dout_player2 = 9) then
            enable_player2 <= '0';
            else
            enable_player2 <= '1';
        end if;   
        
        if (dout_bomb = 9) then
            enable_bomb <= '0';
            else
            enable_bomb <= '1';
        end if; 
        
        -- Als er geldige data in de sprite staat  
        if (vcount >= ((5*Scale*H)+1) and vcount < ((6*Scale*H)+1) and 
        hcount >= ((3*Scale*H)+1) and hcount <= ((4*Scale*H)+1)) then
        
        Data_In <= dout_wall;
                                   
        r_out <= R_Data_Out;         
        g_out <= G_Data_Out;
        b_out <= B_Data_Out;   
        
        elsif (vcount >= ((9*Scale*H)+1) and vcount < ((10*Scale*H)+1) and       --meerder player1 tekenen om te kijken wat de ofsett doet
        hcount >= ((15*scale*H)+1) and hcount < ((16*scale*H)+1) and
        enable_bomb = '1') then

        Data_In <= dout_bomb;
                                   
        r_out <= R_Data_Out;         
        g_out <= G_Data_Out;
        b_out <= B_Data_Out; 
        
        elsif (
        ((vcount >= (1+16) and vcount < ((1*Scale*H)+1+16))) and       
        
        (((hcount >= ((1*Scale*H))+1 and hcount < ((2*Scale*H))+1)) or
        (hcount >= ((16*scale*H)+1) and hcount < ((17*scale*H)+1)))        
        ) then
        
        Data_In <= dout_speed;
                                   
        r_out <= R_Data_Out;         
        g_out <= G_Data_Out;
        b_out <= B_Data_Out;   

        elsif (
        ((vcount >= (1+16) and vcount < ((1*Scale*H)+1+16))) and       
        
        (((hcount >= ((2*Scale*H))+1 and hcount < ((3*Scale*H))+1)) or
        (hcount >= ((17*scale*H)+1) and hcount < ((18*scale*H)+1)))        
        ) then
        
        Data_In <= dout_freeze;
                                   
        r_out <= R_Data_Out;         
        g_out <= G_Data_Out;
        b_out <= B_Data_Out;   

        elsif (
        ((vcount >= (1+16) and vcount < ((1*Scale*H)+1+16))) and       
        
        (((hcount >= ((3*Scale*H))+1 and hcount < ((4*Scale*H))+1)) or
        (hcount >= ((18*scale*H)+1) and hcount < ((19*scale*H)+1)))        
        ) then
        
        Data_In <= dout_bomb_up;
                                   
        r_out <= R_Data_Out;         
        g_out <= G_Data_Out;
        b_out <= B_Data_Out;  
        
        elsif (
        (vcount >= (1+16) and vcount < ((1*Scale*H)+1+16) ) and 
        
        ((hcount >= ((5*Scale*W)+1) and hcount < ((8*Scale*W)+1)) or
        (hcount >= ((12*Scale*W)+1) and hcount < ((15*Scale*W)+1))
        )
        )  
        then
        
        Data_In <= dout_heart;
                                   
        r_out <= R_Data_Out;         
        g_out <= G_Data_Out;
        b_out <= B_Data_Out;  
        
        elsif (vcount >= ((3*Scale*H)+1+y) and vcount < ((4*Scale*H)+1+y) and       --meerder player1 tekenen om te kijken wat de ofsett doet
        hcount >= ((3*scale)+1+x) and hcount < ((3*scale)+1+x+(1*Scale*H)) and
        enable_player1 = '1') then

        Data_In <= dout_player1;
                                   
        r_out <= R_Data_Out;         
        g_out <= G_Data_Out;
        b_out <= B_Data_Out;  
         
        elsif (vcount >= ((13*Scale*H)+1) and vcount < ((14*Scale*H)+1) and 
        hcount >= ((19*Scale*H)+1) and hcount <= ((20*Scale*H)+1)and
        enable_player2 = '1') then
        
        Data_In <= dout_player2;
                                   
        r_out <= R_Data_Out;         
        g_out <= G_Data_Out;
        b_out <= B_Data_Out; 

  
        
        -- Anders achtergrond schrijven
        else    --gray header
            if (vcount >= 1 and vcount < ((2*Scale*H)+1) ) then
            r_out <= x"2";         
            g_out <= x"2";
            b_out <= x"2";   
           
            elsif          -- green grass
            (
            (
            (vcount >= ((3*Scale*H)+1) and vcount < ((4*Scale*H)+1)) or
            (vcount >= ((5*Scale*H)+1) and vcount < ((6*Scale*H)+1)) or
            (vcount >= ((7*Scale*H)+1) and vcount < ((8*Scale*H)+1)) or
            (vcount >= ((9*Scale*H)+1) and vcount < ((10*Scale*H)+1)) or
            (vcount >= ((11*Scale*H)+1) and vcount < ((12*Scale*H)+1)) or
            (vcount >= ((13*Scale*H)+1) and vcount < ((14*Scale*H)+1)) or
        
           (hcount >= ((1*Scale*W)+1)and hcount <= ((2*Scale*W)+1)) or
            (hcount >= ((3*Scale*W)+1) and hcount <= ((4*Scale*W)+1)) or
            (hcount >= ((5*Scale*W)+1) and hcount <= ((6*Scale*W)+1)) or
            (hcount >= ((7*Scale*W)+1) and hcount <= ((8*Scale*W)+1)) or
            (hcount >= ((9*Scale*W)+1) and hcount <= ((10*Scale*W)+1)) or
            (hcount >= ((11*Scale*W)+1) and hcount <= ((12*Scale*W)+1)) or
            (hcount >= ((13*Scale*W)+1) and hcount <= ((14*Scale*W)+1)) or
            (hcount >= ((15*Scale*W)+1) and hcount <= ((16*Scale*W)+1)) or
            (hcount >= ((17*Scale*W)+1) and hcount <= ((18*Scale*W)+1)) or
            (hcount >= ((19*Scale*W)+1) and hcount <= ((20*Scale*W)+1))  
            )
            and
            (
               (vcount >= ((3*Scale*H)+1) and (vcount < ((14*Scale*H)+1)) )
            )
             )
             then       
                
                r_out <= x"0";              
                g_out <= x"2";
                b_out <= x"0";
                  
        --als er geen gras is moet er een muur zijn  
            else
        
                Data_In <= dout_block;
                                   
                r_out <= R_Data_Out;         
                g_out <= G_Data_Out;
                b_out <= B_Data_Out;
        
            end if;  --background  
        end if; --sprite         
end process;

end Behavioral;