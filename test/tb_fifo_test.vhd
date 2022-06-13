library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

library vunit_lib;
context vunit_lib.vunit_context;

entity tb_fifo_test is
    generic (
        runner_cfg : string
    );
end tb_fifo_test ;


architecture tb of tb_fifo_test  is
    constant clk_cykle : time := 20 ns;
    signal nr_clk : integer; --anv�nds inte �n

    component fifo_test
        port(
        data_in : in STD_LOGIC;
        data_out : out STD_LOGIC;
        clk : in STD_LOGIC;
        rst : in STD_LOGIC; --reset om 1 (asynkron)
        write_enable : in STD_LOGIC;
        read_enable : in STD_LOGIC
       );
    end component;
    
    signal clk : STD_LOGIC := '0';
    signal data_in : STD_LOGIC;
    signal rst : STD_LOGIC := '0';
    signal data_out : STD_LOGIC;
    signal write_enable : STD_LOGIC;
    signal read_enable : STD_LOGIC;
    signal v : std_logic_vector(9 downto 0) := "1011011100"; --test number sequense 

begin 

    namn : fifo_test port map(
    data_in => data_in,
    clk => clk,
    rst => rst,
    data_out => data_out,
    write_enable => write_enable,
    read_enable => read_enable
    );
    
    clk <= NOT clk after clk_cykle / 2;

    main : process 
    begin
        test_runner_setup(runner, runner_cfg);

           
        while test_suite loop
            if run("Test_1") then
                --assert message = "set-for-entity";
                --dump_generics;

                data_in <= '1';
                write_enable <= '0', '1' after 20 ns, '0' after 40 ns, '1' after 60 ns;

                read_enable <= '0', '1' after 60 ns, '0' after 80 ns;
    
                rst <= '0', '1' after 195 ns, '0' after 200 ns;

                wait for 400 ns; -- hur l�nge testet ska k�ra

            elsif run("Test_2") then
                --assert message = "set-for-test";
                --dump_generics;
                assert 1 = 1;
                        

            end if;
        end loop;

    test_runner_cleanup(runner);
    end process;
    
test_runner_watchdog(runner, 100 ms);
end architecture;



  --clock : process 
    --begin
        --clk <= '0';
        --wait for T/2;
        --clk <= '1';
        --wait for T/2;
        --nr_clk <= nr_clk + 1;
    --end process;

