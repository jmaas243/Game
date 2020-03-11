----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 03/09/2020 08:19:45 PM
-- Design Name: 
-- Module Name: player1 - Behavioral
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

library UNISIM; 
use UNISIM.Vcomponents.all;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity player1 is
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
end player1;

architecture Behavioral of player1 is

constant c_BITMAP_WIDTH : integer := 16;



signal s_HOffset : integer range 0 to 65535 := 0;
signal s_VOffset : integer range 0 to 65535 := 0;

signal din_block : std_logic_VECTOR(3 downto 0) := (others => '0');
signal dout_block : std_logic_VECTOR(3 downto 0) := (others => '0');
signal addra : std_logic_VECTOR(7 downto 0) := (others => '0');

signal ena : std_logic := '1';
signal wea : std_logic_VECTOR(0 downto 0):="0";

signal read : INTEGER;

signal hor_int, ver_int : INTEGER;

signal s_Data_Out : STD_LOGIC_VECTOR(3 DOWNTO 0) := (others => '0');  
		
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
	
begin
player1_ram : player1_coe
		Port MAP(
		  clka => p_clock,  --clock for writing data to RAM.
           ena => ena,   --Enable signal.
           wea => wea,   --Write enable signal for Port A.
           addra => addra, 
           dina => din_block, 
           douta => dout_block);  
	
		
hor_int <= ((((p_HPos-1)/2) mod 16)+1);
ver_int <= ((((p_VPos-1)/2) mod 16));   

          
--s_Data_Out       <= "0000";
--s_Data_Out  <= "1111";

--Data_Out       <= "1000";

process(p_Clock, p_Reset)
begin
		if p_Reset = '1' then
			Data_Out <= "0000";
			addra <= (others => '0');
			s_HOffset    <= 0;
			s_VOffset    <= 0;
		elsif rising_edge(p_Clock) then
			s_HOffset <= p_HPos;
			s_VOffset <= p_VPos;
			--if (s_HOffset >= 0 and s_HOffset <= c_BITMAP_WIDTH and s_VOffset >= 0 and s_VOffset < c_BITMAP_WIDTH) then
            read <= ((hor_int+(ver_int*16)));

            --addra <= std_logic_vector(to_unsigned(read, addra'length));
            addra <= addra +1;   
			s_Data_Out  <= dout_block;
			--s_Data_Out  <= "0101";
			--	Data_Out <= "0101";
			--else
			--s_Data_Out <= "1000";
			--Data_Out <= "1111";
			--end if;

		end if;
end process;

    Data_Out <= s_Data_Out; 

end Behavioral;
