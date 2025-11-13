<?php

namespace App\Helpers;

class PrintHelper
{
    // Cấu hình màu sắc
    private static $colors = [
        'error' => '#dc3545',
        'success' => '#28a745',
        'warning' => '#ffc107',
        'info' => '#17a2b8',
        'primary' => '#007bff',
        'debug' => '#6c757d'
    ];

    // Cấu hình icon
    private static $icons = [
        'error' => '❌',
        'success' => '✅',
        'warning' => '⚠️',
        'info' => 'ℹ️',
        'debug' => '🔍'
    ];

    /**
     * Cấu hình tùy chỉnh màu sắc
     */
    public static function setColors(array $colors)
    {
        self::$colors = array_merge(self::$colors, $colors);
    }

    /**
     * In ra dữ liệu dưới dạng đẹp với nhiều tùy chọn
     */
    public static function prettyPrint($data, $options = [])
    {
        $defaults = [
            'title' => null,
            'collapse' => false,
            'background' => '#f8f9fa',
            'border' => true,
            'highlight' => true,
            'max_depth' => null
        ];
        
        $opts = array_merge($defaults, $options);
        
        $id = 'pp_' . uniqid();
        $style = self::getPrettyPrintStyle($opts);
        
        echo $style;
        echo '<div class="pretty-print-container" style="margin: 10px 0;">';
        
        if ($opts['title']) {
            echo '<div class="pp-title" onclick="document.getElementById(\'' . $id . '\').style.display = document.getElementById(\'' . $id . '\').style.display === \'none\' ? \'block\' : \'none\'">';
            echo '🔍 ' . htmlspecialchars($opts['title']);
            echo '</div>';
        }
        
        echo '<pre id="' . $id . '" class="pp-content"' . ($opts['collapse'] ? ' style="display:none;"' : '') . '>';
        
        if ($opts['highlight']) {
            echo self::highlightPrint($data, $opts['max_depth']);
        } else {
            print_r($data);
        }
        
        echo '</pre>';
        echo '</div>';
    }

    /**
     * In ra dữ liệu với highlight syntax
     */
    private static function highlightPrint($data, $maxDepth = null, $depth = 0)
    {
        if ($maxDepth !== null && $depth >= $maxDepth) {
            return '...';
        }

        $type = gettype($data);
        $indent = str_repeat('  ', $depth);

        switch ($type) {
            case 'array':
                $output = "Array (\n";
                foreach ($data as $key => $value) {
                    $output .= $indent . '  [<span style="color: #d63384;">' . $key . '</span>] => ';
                    $output .= self::highlightPrint($value, $maxDepth, $depth + 1) . "\n";
                }
                $output .= $indent . ')';
                return $output;

            case 'object':
                return '<span style="color: #0d6efd;">' . get_class($data) . '</span> Object (...)';

            case 'string':
                return '<span style="color: #198754;">"' . htmlspecialchars($data) . '"</span>';

            case 'integer':
            case 'double':
                return '<span style="color: #0dcaf0;">' . $data . '</span>';

            case 'boolean':
                return '<span style="color: #fd7e14;">' . ($data ? 'true' : 'false') . '</span>';

            case 'NULL':
                return '<span style="color: #6c757d;">null</span>';

            default:
                return print_r($data, true);
        }
    }

    /**
     * Style CSS cho prettyPrint
     */
    private static function getPrettyPrintStyle($opts)
    {
        $bg = $opts['background'];
        $border = $opts['border'] ? 'border: 1px solid #dee2e6; border-radius: 6px;' : '';
        
        return '<style>
            .pretty-print-container { font-family: "Courier New", monospace; }
            .pp-title {
                background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
                color: white;
                padding: 10px 15px;
                border-radius: 6px 6px 0 0;
                cursor: pointer;
                font-weight: bold;
                user-select: none;
            }
            .pp-title:hover { opacity: 0.9; }
            .pp-content {
                background: ' . $bg . ';
                padding: 15px;
                ' . $border . '
                overflow-x: auto;
                margin: 0;
                line-height: 1.5;
            }
        </style>';
    }

    /**
     * In ra dữ liệu JSON với options nâng cao
     */
    public static function printJson($data, $options = [])
    {
        $defaults = [
            'pretty' => true,
            'unescaped_unicode' => true,
            'unescaped_slashes' => true,
            'header' => true,
            'download' => false,
            'filename' => 'data.json'
        ];
        
        $opts = array_merge($defaults, $options);
        
        $flags = 0;
        if ($opts['pretty']) $flags |= JSON_PRETTY_PRINT;
        if ($opts['unescaped_unicode']) $flags |= JSON_UNESCAPED_UNICODE;
        if ($opts['unescaped_slashes']) $flags |= JSON_UNESCAPED_SLASHES;
        
        if ($opts['header']) {
            header('Content-Type: application/json; charset=utf-8');
        }
        
        if ($opts['download']) {
            header('Content-Disposition: attachment; filename="' . $opts['filename'] . '"');
        }
        
        echo json_encode($data, $flags);
    }

    /**
     * In ra thông báo với template tùy chỉnh
     */
    public static function printMessage($message, $type = 'info', $options = [])
    {
        $defaults = [
            'dismissible' => false,
            'icon' => true,
            'timestamp' => false,
            'title' => null,
            'animate' => true
        ];
        
        $opts = array_merge($defaults, $options);
        $color = self::$colors[$type] ?? self::$colors['info'];
        $icon = $opts['icon'] ? (self::$icons[$type] ?? '') : '';
        $animation = $opts['animate'] ? 'animation: slideIn 0.3s ease-out;' : '';
        
        echo '<style>
            @keyframes slideIn {
                from { transform: translateY(-20px); opacity: 0; }
                to { transform: translateY(0); opacity: 1; }
            }
            .msg-close { 
                cursor: pointer; 
                float: right; 
                font-size: 20px; 
                line-height: 20px;
                opacity: 0.7;
            }
            .msg-close:hover { opacity: 1; }
        </style>';
        
        echo '<div class="print-message" style="
            background: ' . $color . '15;
            border-left: 4px solid ' . $color . ';
            padding: 15px 20px;
            margin: 10px 0;
            border-radius: 4px;
            color: #333;
            ' . $animation . '
        ">';
        
        if ($opts['dismissible']) {
            echo '<span class="msg-close" onclick="this.parentElement.remove()">×</span>';
        }
        
        if ($icon) {
            echo '<span style="font-size: 18px; margin-right: 10px;">' . $icon . '</span>';
        }
        
        echo '<strong style="color: ' . $color . ';">';
        if ($opts['title']) {
            echo htmlspecialchars($opts['title']) . ': ';
        } else {
            echo ucfirst($type) . ': ';
        }
        echo '</strong>';
        
        echo htmlspecialchars($message);
        
        if ($opts['timestamp']) {
            echo '<div style="font-size: 11px; color: #6c757d; margin-top: 5px;">';
            echo date('Y-m-d H:i:s');
            echo '</div>';
        }
        
        echo '</div>';
    }

    /**
     * Shortcut methods
     */
    public static function printError($message, $options = [])
    {
        self::printMessage($message, 'error', $options);
    }

    public static function printSuccess($message, $options = [])
    {
        self::printMessage($message, 'success', $options);
    }

    public static function printWarning($message, $options = [])
    {
        self::printMessage($message, 'warning', $options);
    }

    public static function printInfo($message, $options = [])
    {
        self::printMessage($message, 'info', $options);
    }

    /**
     * In bảng dữ liệu đẹp
     */
    public static function printTable($data, $options = [])
    {
        $defaults = [
            'title' => null,
            'striped' => true,
            'bordered' => true,
            'hover' => true,
            'headers' => null
        ];
        
        $opts = array_merge($defaults, $options);
        
        if (empty($data)) {
            self::printWarning('Không có dữ liệu để hiển thị');
            return;
        }

        $striped = $opts['striped'] ? 'background: #f8f9fa;' : '';
        $bordered = $opts['bordered'] ? 'border: 1px solid #dee2e6;' : '';
        
        echo '<style>
            .print-table { 
                width: 100%; 
                border-collapse: collapse; 
                margin: 10px 0;
                ' . $bordered . '
            }
            .print-table th {
                background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
                color: white;
                padding: 12px;
                text-align: left;
                font-weight: bold;
            }
            .print-table td {
                padding: 10px 12px;
                border-bottom: 1px solid #dee2e6;
            }
            .print-table tr:nth-child(even) { ' . $striped . ' }
            ' . ($opts['hover'] ? '.print-table tbody tr:hover { background: #e9ecef; }' : '') . '
        </style>';
        
        if ($opts['title']) {
            echo '<h3 style="color: #495057; margin-top: 20px;">' . htmlspecialchars($opts['title']) . '</h3>';
        }
        
        echo '<table class="print-table">';
        
        // Headers
        if ($opts['headers']) {
            $headers = $opts['headers'];
        } else {
            $headers = is_array(reset($data)) ? array_keys(reset($data)) : ['Value'];
        }
        
        echo '<thead><tr>';
        foreach ($headers as $header) {
            echo '<th>' . htmlspecialchars($header) . '</th>';
        }
        echo '</tr></thead>';
        
        // Body
        echo '<tbody>';
        foreach ($data as $row) {
            echo '<tr>';
            if (is_array($row)) {
                foreach ($row as $cell) {
                    echo '<td>' . htmlspecialchars($cell) . '</td>';
                }
            } else {
                echo '<td>' . htmlspecialchars($row) . '</td>';
            }
            echo '</tr>';
        }
        echo '</tbody>';
        
        echo '</table>';
    }

    /**
     * Debug nhanh với trace
     */
    public static function dd(...$vars)
    {
        echo '<style>
            .dd-container {
                background: #1e1e1e;
                color: #d4d4d4;
                padding: 20px;
                border-radius: 8px;
                margin: 10px 0;
                font-family: "Courier New", monospace;
            }
            .dd-trace {
                background: #2d2d2d;
                padding: 10px;
                margin-top: 10px;
                border-radius: 4px;
                font-size: 12px;
            }
        </style>';
        
        echo '<div class="dd-container">';
        foreach ($vars as $var) {
            self::prettyPrint($var, ['background' => '#2d2d2d', 'highlight' => true]);
        }
        
        $trace = debug_backtrace(DEBUG_BACKTRACE_IGNORE_ARGS, 1)[0];
        echo '<div class="dd-trace">📍 ' . $trace['file'] . ':' . $trace['line'] . '</div>';
        echo '</div>';
        
        die(1);
    }
}