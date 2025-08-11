--伯爵的封印(ZCG)
function c77239562.initial_effect(c)
    --Negate Damage
    local e0=Effect.CreateEffect(c)
    e0:SetType(EFFECT_TYPE_ACTIVATE)
    e0:SetCode(EVENT_FREE_CHAIN)
    c:RegisterEffect(e0)

    --Negate Damage
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
    e1:SetCode(EVENT_CHAINING)
    e1:SetRange(LOCATION_SZONE)
    e1:SetCondition(c77239562.con)
    e1:SetCost(c77239562.cost)
    e1:SetTarget(c77239562.destg)
    e1:SetOperation(c77239562.op1)
    c:RegisterEffect(e1)
	
    --no damage
    local e2=Effect.CreateEffect(c)
    e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
    e2:SetRange(LOCATION_SZONE)
    e2:SetCode(EVENT_ATTACK_ANNOUNCE)
    e2:SetCondition(c77239562.con1)
    e2:SetTarget(c77239562.destg)
    e2:SetCost(c77239562.cost)
    e2:SetOperation(c77239562.op1)
    c:RegisterEffect(e2)
end
-------------------------------------------------------------------------------
function c77239562.con(e,tp,eg,ep,ev,re,r,rp)
    local ex,cg,ct,cp,cv=Duel.GetOperationInfo(ev,CATEGORY_DAMAGE)
    if ex and (cp==tp or cp==PLAYER_ALL) then return true end
    ex,cg,ct,cp,cv=Duel.GetOperationInfo(ev,CATEGORY_RECOVER)
    return ex and (cp==tp or cp==PLAYER_ALL) and Duel.IsPlayerAffectedByEffect(tp,EFFECT_REVERSE_RECOVER)
end
--[[function c77239562.op(e,tp,eg,ep,ev,re,r,rp)
    local cid=Duel.GetChainInfo(ev,CHAININFO_CHAIN_ID)
    local e1=Effect.CreateEffect(e:GetHandler())
    e1:SetType(EFFECT_TYPE_FIELD)
    e1:SetCode(EFFECT_CHANGE_DAMAGE)
    e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
    e1:SetTargetRange(1,0)
    e1:SetLabel(cid)
    e1:SetValue(c77239562.refcon)
    e1:SetReset(RESET_CHAIN)
    Duel.RegisterEffect(e1,tp)
    Duel.Hint(HINT_SELECTMSG,tp,562)
    local rc=Duel.AnnounceAttribute(tp,1,0xffff)
	if Duel.GetMatchingGroupCount(c77239562.filter,1-tp,0,LOCATION_DECK+LOCATION_HAND+LOCATION_GRAVE,nil,rc,e,1-tp)>0 then
	    if Duel.GetLocationCount(1-tp,LOCATION_MZONE)<=0 then return end
		Duel.Hint(HINT_SELECTMSG,1-tp,HINTMSG_SPSUMMON)
        local g=Duel.SelectMatchingCard(1-tp,c77239562.filter,tp,0,LOCATION_DECK+LOCATION_HAND+LOCATION_GRAVE,1,1,nil,rc,1-tp)
        if g:GetCount()>0 then
            Duel.SpecialSummon(g,0,1-tp,1-tp,false,false,POS_FACEUP)
        end
	end
end
function c77239562.filter(c,e,tp,rc)
    return c:IsAttribute(rc) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c77239562.refcon(e,re,val,r,rp,rc)
    local cc=Duel.GetCurrentChain()
    if cc==0 or bit.band(r,REASON_EFFECT)==0 then return end
    local cid=Duel.GetChainInfo(0,CHAININFO_CHAIN_ID)
    if cid==e:GetLabel() then return 0
    else return val end
end
function c77239562.desfilter(c,att)
	return c:IsAttribute(att)
end]]

function c77239562.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(aux.TRUE,tp,0,LOCATION_ONFIELD,1,nil) end
	local g=Duel.GetMatchingGroup(aux.TRUE,tp,0,LOCATION_ONFIELD,nil)
	local tc=g:GetFirst()
	local attr=0
	for tc in aux.Next(g) do
		attr=(attr|tc:GetAttribute())
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATTRIBUTE)
	local arc=Duel.AnnounceAttribute(tp,1,attr)
	e:SetLabel(arc)
	local dg=g:Filter(Card.IsAttribute,nil,arc)
	Duel.SetOperationInfo(0,CATEGORY_DISABLE,dg,#dg,0,0)
end

--[[function c77239562.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetMatchingGroup(aux.TRUE,1-tp,LOCATION_DECK,0,nil)
	if chk==0 then
		if #g==0 then return false end
		local tc=g:GetFirst()
		local att=0
		for tc in aux.Next(g) do
			att=(att|tc:GetAttribute())
		end
		return (att&att-1)~=0
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,0,0)
end
function c77239562.op(e,tp,eg,ep,ev,re,r,rp)
    local cid=Duel.GetChainInfo(ev,CHAININFO_CHAIN_ID)
    local e1=Effect.CreateEffect(e:GetHandler())
    e1:SetType(EFFECT_TYPE_FIELD)
    e1:SetCode(EFFECT_CHANGE_DAMAGE)
    e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
    e1:SetTargetRange(1,0)
    e1:SetLabel(cid)
    e1:SetValue(c77239562.refcon)
    e1:SetReset(RESET_CHAIN)
    Duel.RegisterEffect(e1,tp)
	local sg=Duel.GetMatchingGroup(aux.TRUE,1-tp,LOCATION_DECK,0,nil)
	if #sg==0 then return false end
	local tc=sg:GetFirst()
	local att=0
	for tc in aux.Next(sg) do
		att=(att|tc:GetAttribute())
	end
	if (att&att-1)==0 and Duel.GetLocationCount(1-tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATTRIBUTE)
	local att1=Duel.AnnounceAttribute(tp,1,att)
    local g=Duel.SelectTarget(1-tp,c77239562.desfilter,1-tp,LOCATION_DECK,0,1,1,nil,att1,1-tp)
    local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and Duel.SpecialSummon(g,0,1-tp,1-tp,false,false,POS_FACEUP) then
        local e1=Effect.CreateEffect(e:GetHandler())
	    e1:SetType(EFFECT_TYPE_SINGLE)
	    e1:SetCode(EFFECT_UPDATE_ATTACK)
	    e1:SetValue(-2000)
        e1:SetReset(RESET_EVENT+0x1ff0000)
	    tc:RegisterEffect(e1,true)
        local e2=Effect.CreateEffect(e:GetHandler())
	    e2:SetType(EFFECT_TYPE_SINGLE)
	    e2:SetCode(EFFECT_UPDATE_DEFENSE)
	    e2:SetValue(-2000)
        e2:SetReset(RESET_EVENT+0x1ff0000)
	    tc:RegisterEffect(e2,true)
        local e3=Effect.CreateEffect(e:GetHandler())
        e3:SetType(EFFECT_TYPE_SINGLE)
        e3:SetCode(EFFECT_CANNOT_ATTACK)
        tc:RegisterEffect(e3,true)
        local e4=e3:Clone()
        e4:SetCode(EFFECT_CANNOT_CHANGE_POSITION)
        tc:RegisterEffect(e4,true)
        local e5=e3:Clone()
        e5:SetCode(EFFECT_CANNOT_CHANGE_CONTROL)
        tc:RegisterEffect(e5,true)
        local e6=Effect.CreateEffect(e:GetHandler())
        e6:SetType(EFFECT_TYPE_SINGLE)
        e6:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
        e6:SetRange(LOCATION_MZONE)
        e6:SetCode(EFFECT_UNRELEASABLE_SUM)
        e6:SetValue(1)
        tc:RegisterEffect(e6,true)
        local e7=e6:Clone()
        e7:SetCode(EFFECT_UNRELEASABLE_NONSUM)
        tc:RegisterEffect(e7,true)
        local e8=e7:Clone()
        e8:SetCode(EFFECT_CANNOT_SSET)
        tc:RegisterEffect(e8,true)
        local e9=Effect.CreateEffect(e:GetHandler())
		e9:SetType(EFFECT_TYPE_SINGLE)
		e9:SetCode(EFFECT_CANNOT_BE_SYNCHRO_MATERIAL)
		e9:SetValue(1)
		tc:RegisterEffect(e9,true)
        local e10=e9:Clone()
        e10:SetCode(EFFECT_CANNOT_BE_XYZ_MATERIAL)
        tc:RegisterEffect(e10,true)
        local e11=e10:Clone()
        e11:SetCode(EFFECT_CANNOT_BE_LINK_MATERIAL)
        tc:RegisterEffect(e11,true)
        local e12=Effect.CreateEffect(e:GetHandler())
		e12:SetType(EFFECT_TYPE_SINGLE)
		e12:SetCode(EFFECT_DISABLE)
		e12:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e12,true)
		local e13=e12:Clone()
		e13:SetCode(EFFECT_DISABLE_EFFECT)
		tc:RegisterEffect(e13,true)
    end
end
-------------------------------------------------------------------------------
function c77239562.con1(e,tp,eg,ep,ev,re,r,rp)
    local at=Duel.GetAttacker()
    return at:GetControler()~=tp
end
function c77239562.op1(e,tp,eg,ep,ev,re,r,rp)
    local e1=Effect.CreateEffect(e:GetHandler())
    e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
    e1:SetCode(EVENT_PRE_BATTLE_DAMAGE)
    e1:SetOperation(c77239562.damop)
    e1:SetReset(RESET_PHASE+PHASE_DAMAGE)
    Duel.RegisterEffect(e1,tp)
    Duel.Hint(HINT_SELECTMSG,tp,562)
    local rc=Duel.AnnounceAttribute(tp,1,0xffff)
	if Duel.GetMatchingGroupCount(c77239562.filter,1-tp,LOCATION_DECK+LOCATION_HAND+LOCATION_GRAVE,0,nil,rc,e,1-tp)>0 then
	    if Duel.GetLocationCount(1-tp,LOCATION_MZONE)<=0 then return end
		Duel.Hint(HINT_SELECTMSG,1-tp,HINTMSG_SPSUMMON)
        local g=Duel.SelectMatchingCard(1-tp,c77239562.filter,1-tp,LOCATION_DECK+LOCATION_HAND+LOCATION_GRAVE,0,1,1,nil,rc,e,1-tp)
        if g:GetCount()>0 then
            Duel.SpecialSummon(g,0,1-tp,1-tp,false,false,POS_FACEUP)
        end
	end
end]]
--------------------------------------------------------------------

function c77239562.cost(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(Card.IsDiscardable,tp,LOCATION_HAND,0,1,e:GetHandler()) end
    Duel.DiscardHand(tp,Card.IsDiscardable,1,1,REASON_COST+REASON_DISCARD)
end

function c77239562.con1(e,tp,eg,ep,ev,re,r,rp)
    return tp~=Duel.GetTurnPlayer()
end

function c77239562.op1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local arc=e:GetLabel()
	local g=Duel.GetMatchingGroup(aux.FaceupFilter(Card.IsAttribute,arc),tp,0,LOCATION_ONFIELD,nil)
	if #g>0 then
        local tc=g:GetFirst()
        local e1=Effect.CreateEffect(e:GetHandler())
	    e1:SetType(EFFECT_TYPE_SINGLE)
	    e1:SetCode(EFFECT_UPDATE_ATTACK)
	    e1:SetValue(-2000)
        e1:SetReset(RESET_EVENT+RESETS_STANDARD)
	    tc:RegisterEffect(e1,true)
        local e2=Effect.CreateEffect(e:GetHandler())
	    e2:SetType(EFFECT_TYPE_SINGLE)
	    e2:SetCode(EFFECT_UPDATE_DEFENSE)
	    e2:SetValue(-2000)
        e2:SetReset(RESET_EVENT+RESETS_STANDARD)
	    tc:RegisterEffect(e2,true)
        local e3=Effect.CreateEffect(e:GetHandler())
        e3:SetType(EFFECT_TYPE_SINGLE)
        e3:SetCode(EFFECT_CANNOT_ATTACK)
        tc:RegisterEffect(e3,true)
        local e4=e3:Clone()
        e4:SetCode(EFFECT_CANNOT_CHANGE_POSITION)
        tc:RegisterEffect(e4,true)
        local e5=e3:Clone()
        e5:SetCode(EFFECT_CANNOT_CHANGE_CONTROL)
        tc:RegisterEffect(e5,true)
        local e6=Effect.CreateEffect(e:GetHandler())
        e6:SetType(EFFECT_TYPE_SINGLE)
        e6:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
        e6:SetRange(LOCATION_MZONE)
        e6:SetCode(EFFECT_UNRELEASABLE_SUM)
        e6:SetValue(1)
        tc:RegisterEffect(e6,true)
        local e7=e6:Clone()
        e7:SetCode(EFFECT_UNRELEASABLE_NONSUM)
        tc:RegisterEffect(e7,true)
        local e8=e7:Clone()
        e8:SetCode(EFFECT_CANNOT_SSET)
        tc:RegisterEffect(e8,true)
        local e9=Effect.CreateEffect(e:GetHandler())
		e9:SetType(EFFECT_TYPE_SINGLE)
		e9:SetCode(EFFECT_CANNOT_BE_MATERIAL)
        e9:SetValue(aux.cannotmatfilter(SUMMON_TYPE_SYNCHRO,SUMMON_TYPE_XYZ,SUMMON_TYPE_LINK))
        tc:RegisterEffect(e9,true)
        local e12=Effect.CreateEffect(e:GetHandler())
		e12:SetType(EFFECT_TYPE_SINGLE)
		e12:SetCode(EFFECT_DISABLE)
		e12:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e12,true)
		local e13=e12:Clone()
		e13:SetCode(EFFECT_DISABLE_EFFECT)
	end
end
-------------------------------------------------------------------------------