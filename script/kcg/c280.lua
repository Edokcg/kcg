-- The Fang of Critias
local s, id = GetID()
function s.initial_effect(c)
    local e1 = Effect.CreateEffect(c)
    e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_FUSION_SUMMON)
    e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_CANNOT_INACTIVATE+EFFECT_FLAG_CANNOT_NEGATE)
    e1:SetDescription(aux.Stringid(44, 0))
    e1:SetType(EFFECT_TYPE_ACTIVATE)
    e1:SetCode(EVENT_FREE_CHAIN)
    e1:SetTarget(s.target)
    e1:SetOperation(s.activate)
    c:RegisterEffect(e1)

    local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(id,3))
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e3:SetCode(EFFECT_SPSUMMON_PROC)
	e3:SetRange(LOCATION_HAND)
	e3:SetCondition(s.spcon)
	e3:SetTarget(s.sptg)
	e3:SetOperation(s.spop)
	c:RegisterEffect(e3)
    
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,0))
    e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_CANNOT_INACTIVATE)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1)
	e2:SetTarget(s.atarget)
	e2:SetOperation(s.aactivate)
	c:RegisterEffect(e2)
end
s.list = {
    [57728570] = 279,
    [44095762] = 283,
    [57470761] = 285,
    [83555666] = 361
}

function s.filter(c,e,tp)
    return Duel.GetLocationCountFromEx(tp,tp,c,TYPE_FUSION)>0 
    and (c:IsControler(tp) or c:IsFaceup()) and c:IsType(TYPE_TRAP)
    and not c:IsImmuneToEffect(e) and c:IsAbleToGrave()
    and not c:IsSetCard(0xa1) and not c:IsSetCard(0xa0)
end

function s.target(e, tp, eg, ep, ev, re, r, rp, chk)
    if chk == 0 then
        return Duel.IsExistingMatchingCard(s.filter,tp,LOCATION_SZONE,0,1,nil,e,tp)
        and Duel.IsPlayerCanSpecialSummon(tp,SUMMON_TYPE_FUSION,POS_FACEUP,tp,e:GetHandler())
    end
    Duel.SetOperationInfo(0, CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function s.activate(e, tp, eg, ep, ev, re, r, rp)
    local c=e:GetHandler()
    if not Duel.IsExistingMatchingCard(s.filter,tp,LOCATION_SZONE,0,1,nil,e,tp) or not Duel.IsPlayerCanSpecialSummon(tp,SUMMON_TYPE_FUSION,POS_FACEUP,tp,e:GetHandler()) then return end
    Duel.Hint(HINT_SELECTMSG, tp, HINTMSG_FMATERIAL)
    local rg=Duel.SelectMatchingCard(tp,s.filter,tp,LOCATION_SZONE,0,1,1,nil,e,tp)
    if #rg<1 then return end
    if rg:GetFirst():IsFacedown() then Duel.ConfirmCards(tp,rg:GetFirst()) end
    local ttcode=0
    local acode=rg:GetFirst():GetOriginalAlias()
    local ocode=rg:GetFirst():GetOriginalCode()
    local tcode=s.list[acode]
    if tcode then
		ttcode=tcode
	else
		ttcode=43
	end
    local tc=Duel.CreateToken(tp,ttcode,nil,nil,nil,nil,nil,nil)
    local fg=rg
	fg:AddCard(c)
    if Duel.SendtoDeck(tc,tp,0,REASON_RULE+REASON_EFFECT)>0 then
        tc:SetMaterial(fg)
        Duel.SendtoGrave(fg,REASON_EFFECT+REASON_MATERIAL+REASON_FUSION)
        Duel.BreakEffect()
        if tc:IsCode(43) then
            local ss={rg:GetFirst():GetOriginalSetCard()}
            local addset=false
            if #ss>3 then
                addset=true
            else
                table.insert(ss,0xa1)
            end
            local rrealcode,orcode,rrealalias=rg:GetFirst():GetRealCode()
            if rrealcode>0 then 
                ocode=orcode
                acode=orcode
            end
            if rrealcode>0 then
                tc:SetEntityCode(ocode,nil,ss,TYPE_MONSTER+TYPE_FUSION+TYPE_EFFECT,8,ATTRIBUTE_LIGHT,RACE_DRAGON,2800,2500,nil,nil,nil,false,43,43,43,rg:GetFirst())
            else
                tc:SetEntityCode(ocode,nil,ss,TYPE_MONSTER+TYPE_FUSION+TYPE_EFFECT,8,ATTRIBUTE_LIGHT,RACE_DRAGON,2800,2500,nil,nil,nil,false,43,43,43)
            end
            if addset then
                local e1=Effect.CreateEffect(tc)
                e1:SetType(EFFECT_TYPE_SINGLE)
                e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
                e1:SetCode(EFFECT_ADD_SETCODE)
                e1:SetValue(0xa1)
                tc:RegisterEffect(e1)
            end
            aux.CopyCardTable(rg:GetFirst(),tc,false,"listed_names",id,acode)
            tc.__index.material_trap=acode
            local tequip=false
            local tec = {rg:GetFirst():GetTriggerEffect()}
            if tec then
                for _, te in ipairs(tec) do
                    if (bit.band(te:GetType(), EFFECT_TYPE_QUICK_O) ~= 0 or bit.band(te:GetType(), EFFECT_TYPE_TRIGGER_O) ~= 0 or bit.band(te:GetType(), EFFECT_TYPE_ACTIVATE) ~= 0)
                    and te:GetOperation() then
                        local cost=te:GetCost()
                        local target=te:GetTarget()
                        local te2 = te:Clone()
                        te2:SetOwner(tc)
                        te2:SetCost(function(...) return true end)
                        te2:SetCountLimit(1)
                        if te:GetRange() then
                            te2:SetRange(LOCATION_MZONE)
                        end
                        local equip=false
                        if bit.band(te:GetType(), EFFECT_TYPE_ACTIVATE) ~= 0 then
                            if te:GetCode() == EVENT_FREE_CHAIN then
                                te2:SetType(EFFECT_TYPE_IGNITION)
                                if te:IsHasCategory(CATEGORY_EQUIP) then
                                    equip=true
                                    tequip=true
                                end
                            else
                                te2:SetType(EFFECT_TYPE_QUICK_O)
                            end
                        end
                        if equip then
                            te2:SetTarget(s.eqtg)
                            te2:SetOperation(s.eqop)
                            local e1=Effect.CreateEffect(tc)
                            e1:SetProperty(EFFECT_FLAG_CLIENT_HINT+EFFECT_FLAG_CANNOT_DISABLE)
                            e1:SetDescription(aux.Stringid(43,0),true)
                            e1:SetType(EFFECT_TYPE_SINGLE)
                            e1:SetCode(id)
                            tc:RegisterEffect(e1)
                        elseif cost then
                            te2:SetTarget(function(e,tp,eg,ep,ev,re,r,rp,chk) 
                                te2:SetLabel(1)
                                if chk==0 then return target(e,tp,eg,ep,ev,re,r,rp,0) end
                                target(e,tp,eg,ep,ev,re,r,rp,1)
                            end)
                        end
                        tc:RegisterEffect(te2, true)
                    end
                end
            end
            if tequip then
                local tec2 = {rg:GetFirst():GetEquipEffect()}
                for _, te in ipairs(tec2) do
                    local te2 = te:Clone()
                    te2:SetOwner(tc)
                    tc:RegisterEffect(te2, true)
                end
                local e1=Effect.CreateEffect(tc)
                e1:SetProperty(EFFECT_FLAG_CLIENT_HINT+EFFECT_FLAG_CANNOT_DISABLE)
                e1:SetDescription(aux.Stringid(43,1),true,0,0,0,0,ocode)
                e1:SetType(EFFECT_TYPE_SINGLE)
                e1:SetCode(id)
                tc:RegisterEffect(e1)
            end
            local e1=Effect.CreateEffect(tc)
            e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
            e1:SetType(EFFECT_TYPE_SINGLE)
            e1:SetCode(EFFECT_CANNOT_DISABLE)
            tc:RegisterEffect(e1)
        else
            tc:SetEntityCode(ttcode,nil,nil,tc:GetOriginalType()|TYPE_EFFECT|TYPE_FUSION,nil,nil,nil,nil,nil,nil,nil,nil,false,ttcode,ttcode,43,false,true)
        end
        Duel.SpecialSummon(tc,SUMMON_TYPE_FUSION,tp,tp,true,false,POS_FACEUP)
        tc:CompleteProcedure()
    end
end
function s.eqtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and chkc:IsFaceup() and chkc~=e:GetHandler() end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_SZONE)>0
		and Duel.IsExistingTarget(Card.IsFaceup,tp,LOCATION_MZONE,0,1,e:GetHandler()) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
	Duel.SelectTarget(tp,Card.IsFaceup,tp,LOCATION_MZONE,0,1,1,e:GetHandler())
end
function s.eqop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) or c:IsLocation(LOCATION_SZONE) or c:IsFacedown() then return end
	local tc=Duel.GetFirstTarget()
	if Duel.GetLocationCount(tp,LOCATION_SZONE)<=0 or tc:GetControler()~=tp or tc:IsFacedown() or not tc:IsRelateToEffect(e) then
		Duel.SendtoGrave(c,REASON_EFFECT)
		return
	end
	Duel.Equip(tp,c,tc,true)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_EQUIP_LIMIT)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD)
	e1:SetLabelObject(tc)
	e1:SetValue(s.eqlimit)
	c:RegisterEffect(e1)
	-- local e8 = Effect.CreateEffect(c)
	-- e8:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE+EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL+EFFECT_FLAG_CANNOT_DISABLE)
	-- e8:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	-- e8:SetCode(EVENT_LEAVE_FIELD_P)
	-- e8:SetOperation(s.recover)
	-- e8:SetLabel(tc:GetOriginalCode())
	-- e8:SetReset(RESET_EVENT + 0x1fe0000)
	-- c:RegisterEffect(e8, true)
	-- local e9 = Effect.CreateEffect(c)
	-- e9:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE+EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL+EFFECT_FLAG_CANNOT_DISABLE)
	-- e9:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	-- e9:SetCode(EVENT_LEAVE_FIELD_P)
	-- e9:SetRange(LOCATION_SZONE)
	-- e9:SetOperation(s.recover2)
	-- e9:SetLabel(tc:GetOriginalCode())
	-- e9:SetReset(RESET_EVENT+0x1fe0000)
	-- c:RegisterEffect(e9, true)
	local atk=tc:GetTextAttack()
	local def=tc:GetTextDefense()
	tc:SetEntityCode(363,nil,nil,nil,nil,nil,nil,nil,nil,nil,nil,nil,EFFECT_FLAG_CANNOT_DISABLE|EFFECT_FLAG_OWNER_RELATE,RESET_EVENT+RESETS_STANDARD,c,true)
	--atkup
	local e2=Effect.CreateEffect(c)
	e2:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE+EFFECT_FLAG_CANNOT_DISABLE)
	e2:SetType(EFFECT_TYPE_EQUIP)
	e2:SetCode(EFFECT_SET_BASE_ATTACK)
	e2:SetValue(atk+400)
	e2:SetReset(RESET_EVENT+RESETS_STANDARD)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EFFECT_SET_BASE_DEFENSE)
	e3:SetValue(def+400)
	c:RegisterEffect(e3)
end
function s.eqlimit(e,c)
	return c==e:GetLabelObject()
end
function s.stfilter(c)
	return c:IsType(TYPE_TRAP) and c:IsSSetable()
end
function s.fgtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and s.stfilter(chkc) end
	local c=e:GetHandler()
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_SZONE)>0
		and Duel.IsExistingTarget(s.stfilter,tp,LOCATION_GRAVE,0,1,nil)
		and c:GetFlagEffect(id)==0 end
	c:RegisterFlagEffect(id,RESET_EVENT+RESETS_STANDARD-RESET_TOGRAVE-RESET_REMOVE-RESET_LEAVE+RESET_PHASE+PHASE_END,0,1)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
	local g=Duel.SelectTarget(tp,s.stfilter,tp,LOCATION_GRAVE,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_LEAVE_GRAVE,g,1,0,0)
end
function s.fgop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc and tc:IsRelateToEffect(e) and tc:IsSSetable() then
		Duel.SSet(tp,tc)
	end
end

function s.filter2(c,ec,code)
	return c:GetEquipTarget()==ec and c:IsCode(code)
end
function s.recover(e,tp,eg,ep,ev,re,r,rp)
	local code=e:GetLabel()
	local c=e:GetHandler()
	local ec=e:GetHandler():GetEquipTarget()
	if ec and not ec:IsOriginalCode(id) then
		ec:SetEntityCode(code,nil,nil,nil,nil,nil,nil,nil,nil,nil,nil,nil,true)
	end
end
function s.recover2(e,tp,eg,ep,ev,re,r,rp)
	local code=e:GetLabel()
	local c=e:GetHandler()
	local ec=e:GetHandler():GetEquipTarget()
	if ec and eg:IsContains(ec) and not ec:IsOriginalCode(id) then
		ec:SetEntityCode(code,nil,nil,nil,nil,nil,nil,nil,nil,nil,nil,nil,true)
	end
end


function s.spcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.IsExistingMatchingCard(Card.IsDiscardable,tp,LOCATION_HAND,0,1,c)
end
function s.sptg(e,tp,eg,ep,ev,re,r,rp,chk,c)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DISCARD)
	local g=Duel.SelectMatchingCard(tp,Card.IsDiscardable,tp,LOCATION_HAND,0,0,1,c)
	if #g>0 then
		g:KeepAlive()
		e:SetLabelObject(g)
		return true
	end
	return false
end
function s.spop(e,tp,eg,ep,ev,re,r,rp,c)
	local g=e:GetLabelObject()
	if not g then return end
	Duel.SendtoGrave(g,REASON_DISCARD|REASON_COST)
	g:DeleteGroup()
end


function s.setfilter(c)
	return c:IsSSetable() and c:IsType(TYPE_TRAP)
end
function s.atarget(e,tp,eg,ep,ev,re,r,rp,chk)
    local b1=Duel.IsExistingMatchingCard(s.filter,tp,LOCATION_SZONE,0,1,nil,e,tp)
        and Duel.IsPlayerCanSpecialSummon(tp,SUMMON_TYPE_FUSION,POS_FACEUP,tp,e:GetHandler())
	local b2=Duel.IsExistingMatchingCard(s.setfilter,tp,LOCATION_DECK,0,1,nil)
	if chk==0 then return b1 or b2 end
	local op=Duel.SelectEffect(tp,
		{b1,aux.Stringid(44,0)},
		{b2,aux.Stringid(id,2)})
    if op==1 then
        e:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_FUSION_SUMMON)
	    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
    elseif op==2 then
        e:SetCategory(CATEGORY_SEARCH)
        Duel.SetOperationInfo(0,CATEGORY_SEARCH,nil,1,tp,LOCATION_DECK)
	end
	Duel.SetTargetParam(op)
end
function s.aactivate(e,tp,eg,ep,ev,re,r,rp)
	local op=Duel.GetChainInfo(0,CHAININFO_TARGET_PARAM)
	local c=e:GetHandler()
	if op==1 then
		s.activate(e,tp,eg,ep,ev,re,r,rp)
	elseif op==2 then
        Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
        local g=Duel.SelectMatchingCard(tp,s.setfilter,tp,LOCATION_DECK,0,1,1,nil)
	    if #g>0 then
            Duel.SSet(tp,g,tp,true)
            Duel.ConfirmCards(1-tp,g)
	    end
    end
end