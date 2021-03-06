library ieee;
use ieee.std_logic_1164.all;

library vunit_lib;
context vunit_lib.vunit_context;

use work.matrix_type.all;

entity tb_full_sample is
   generic (
      runner_cfg : string
   );
end tb_full_sample;

architecture tb of tb_full_sample is
   constant C_CLK_CYKLE : time := 10 ns;

   signal clk   : std_logic := '0';
   signal reset : std_logic := '0';

   signal chain_x4_matrix_data_in : matrix_4_16_24_type          := (others => (others => (others => '0')));
   signal chain_matrix_valid_in   : std_logic_vector(3 downto 0) := "0000";

   signal array_matrix_valid_out : std_logic;
   signal array_matrix_data_out  : matrix_4_16_24_type;

   signal data_change_counter   : integer := 1;
   signal data_valid_in_counter : integer := 0;

   signal temp_matrix_16_24 : matrix_16_24_type;

   signal data_test1, data_test2, data_test3, data_test4, data_test5, data_test6, data_test7, data_test8, data_test9, data_test10, data_test11, data_test12, data_test13, data_test14, data_test15, data_test16 : std_logic_vector(23 downto 0);
begin

   full_sample_1 : entity work.full_sample port map(
      clk                     => clk,
      reset                   => reset,
      chain_x4_matrix_data_in => chain_x4_matrix_data_in,
      chain_matrix_valid_in   => chain_matrix_valid_in,
      array_matrix_data_out   => array_matrix_data_out,
      array_matrix_valid_out  => array_matrix_valid_out
      );

   clk <= not(clk) after C_CLK_CYKLE/2;

   rd_enable_p : process (clk)
   begin
      if rising_edge(clk) then
         if data_valid_in_counter = 10 then
            chain_matrix_valid_in <= "1111";
            data_valid_in_counter <= 0;
         else
            chain_matrix_valid_in <= "0000";
            data_valid_in_counter <= data_valid_in_counter + 1;
         end if;
      end if;
   end process;
   bitgen_p : process (clk)
   begin
      if rising_edge(clk) then
         if data_change_counter = 31 then
            data_change_counter <= 0;
         else
            if data_change_counter < 15 then
               chain_x4_matrix_data_in <= (others => (others => (others => '0')));
            elsif data_change_counter >= 16 then
               chain_x4_matrix_data_in <= (others => (others => (others => '1')));
            end if;
            data_change_counter <= data_change_counter + 1;
         end if;
      end if;
   end process;

   temp_matrix_16_24 <= array_matrix_data_out(0);
   data_test1        <= temp_matrix_16_24(0);
   data_test2        <= temp_matrix_16_24(1);
   data_test3        <= temp_matrix_16_24(2);
   data_test4        <= temp_matrix_16_24(3);
   data_test5        <= temp_matrix_16_24(4);
   data_test6        <= temp_matrix_16_24(5);
   data_test7        <= temp_matrix_16_24(6);
   data_test8        <= temp_matrix_16_24(7);
   data_test9        <= temp_matrix_16_24(8);
   data_test10       <= temp_matrix_16_24(9);
   data_test11       <= temp_matrix_16_24(10);
   data_test12       <= temp_matrix_16_24(11);
   data_test13       <= temp_matrix_16_24(12);
   data_test14       <= temp_matrix_16_24(13);
   data_test15       <= temp_matrix_16_24(14);
   data_test16       <= temp_matrix_16_24(15);

   main : process
   begin

      test_runner_setup(runner, runner_cfg);
      while test_suite loop
         if run("wave") then

            wait for 3000 ns;

         elsif run("auto") then

            wait for 110 ns;

         end if;
      end loop;

      test_runner_cleanup(runner);
   end process;

   test_runner_watchdog(runner, 100 ms);
end architecture;