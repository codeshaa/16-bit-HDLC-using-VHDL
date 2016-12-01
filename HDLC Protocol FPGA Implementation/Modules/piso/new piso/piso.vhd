----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    17:28:42 11/27/2013 
-- Design Name: 
-- Module Name:    piso - Behavioral 
-- Project Name: 
-- Target Devices: 
-- Tool versions: 
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
use IEEE.STD_LOGIC_1164.all;

entity piso is
     port(
         clk : in STD_LOGIC;
         reset : in STD_LOGIC;
         load : in STD_LOGIC;
         din : in STD_LOGIC_VECTOR(3 downto 0);
         dout : out STD_LOGIC
         );
end piso;


architecture piso_arc of piso is
begin

     process (clk,reset,load,din) is
    variable temp : std_logic_vector (din'range);
    begin
        if (reset='1') then
            temp := (others=>'0');
        elsif (load='1') then
            temp := din ;
        elsif (rising_edge (clk)) then
            dout <= temp(3);
            temp := temp(2 downto 0) & '0';
        end if;
    end process;

end piso_arc;
