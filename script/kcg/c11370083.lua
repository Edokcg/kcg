--Seventh Arrival
local s,id=GetID()
function s.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCost(s.cost)
	e1:SetTarget(s.target)
	e1:SetOperation(s.activate)
	c:RegisterEffect(e1)
end

function s.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckReleaseGroup(tp,nil,1,nil) end
	local g0=Duel.GetReleaseGroup(tp)
	local ct0=g0:FilterCount(Card.IsType,nil,TYPE_XYZ)
	local count=Duel.Release(g0,REASON_COST)
	e:SetLabel(count)
end
function s.filter(c,e,tp)
	return c:IsType(TYPE_XYZ) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(aux.NecroValleyFilter(s.filter),tp,LOCATION_REMOVED+LOCATION_GRAVE,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,0,0)
end
function s.activate(e,tp,eg,ep,ev,re,r,rp)
	local count=e:GetLabel()+1
	local c=e:GetHandler()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local sg=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(s.filter),tp,LOCATION_REMOVED+LOCATION_GRAVE,0,1,1,nil,e,tp)
	if #sg<1 then return end
	local tc=sg:GetFirst()
	if Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)==0 then return end
    local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DAMAGE)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCountLimit(1)
	e1:SetCode(EVENT_PHASE+PHASE_BATTLE)
	e1:SetTarget(s.destg)
	e1:SetOperation(s.desop)
	e1:SetReset(RESET_PHASE+PHASE_END) 
	Duel.RegisterEffect(e1,tp)
    if tc:GetFlagEffect(id)==0 then
        tc:RegisterFlagEffect(id,RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(id,0))
        local tec={tc:GetFieldEffect()}
        for _, te in ipairs(tec) do
            if te:GetCode() == 511002571 and te:GetLabelObject() then
                local tee = te:Clone()
                local te2 = te:GetLabelObject()
                local tee2 = te2:Clone()
                te:Reset()
                te2:Reset()
                local cond = te2:GetCondition()
                tee2:SetCondition(function(ae,...) return (not cond or cond(ae,...)) and ae:GetHandler():GetFlagEffect(id) == 0 end)
                tc:RegisterEffect(tee2, true)
                tee:SetLabelObject(tee2)
                tc:RegisterEffect(tee, true)
            end
            if te:GetCode() == 511001363 then
                local tee = te:Clone()
                te:Reset()
                local cond = tee:GetCondition()
                tee:SetCondition(function(ae,...) return (not cond or cond(ae,...)) and ae:GetHandler():GetFlagEffect(id) == 0 end)
                tc:RegisterEffect(tee, true)
            end
        end
    end
    local g=Duel.GetMatchingGroup(aux.NecroValleyFilter(s.atfilter),tp,LOCATION_REMOVED+LOCATION_GRAVE,0,tc)
	if #g<1 or count<1 or tc:IsImmuneToEffect(e)
    or not Duel.SelectYesNo(tp,aux.Stringid(id,1)) then return end
    Duel.BreakEffect()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_XMATERIAL)
	local dg=g:Select(tp,1,count,nil)
	Duel.Overlay(tc,dg)
end
function s.atfilter(c)
	local no=c.xyz_number
	return no and no>=101 and no<=107 and (c:IsLocation(LOCATION_GRAVE) or c:IsFaceup())
end
function s.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local dam=Duel.GetFieldGroupCount(tp,LOCATION_HAND,LOCATION_HAND)*300
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,PLAYER_ALL,dam)
end
function s.desop(e,tp,eg,ep,ev,re,r,rp)
	local count=Duel.GetFieldGroupCount(tp,LOCATION_HAND,LOCATION_HAND)*300
	Duel.Damage(tp,count,REASON_EFFECT)
	Duel.Damage(1-tp,count,REASON_EFFECT)
end