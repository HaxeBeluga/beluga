package beluga.module.ticket.widget;

import beluga.core.Beluga;
import beluga.core.widget.MttWidget;
import beluga.core.macro.ConfigLoader;
import beluga.module.ticket.Ticket;
import beluga.core.BelugaI18n;


class Browse extends MttWidget {
    public var i18n : Dynamic;

    public function new (mttfile = "beluga_ticket_browse.mtt") {
        super(mttfile);
        i18n = BelugaI18n.loadI18nFolder("/module/ticket/view/local/browse/", mod.i18n);
    }

    override private function getContext() {
        var context = mod.getBrowseContext();
        context.base_url = ConfigLoader.getBaseUrl();
        context.id = MttWidget.id++;
        return context;
    }

    override function getMacro()
    {
        var m = {
            i18n: MttWidget.getI18nKey.bind(_, i18n, _)
        };
        return m;
    }
}