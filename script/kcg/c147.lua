--究極封印神エクゾディオス
local s, id = GetID()
function s.initial_effect(c)
	c:EnableReviveLimit()

	--cannot special summon
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	c:RegisterEffect(e1)

	--special summon
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_SPSUMMON_PROC)
	e2:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e2:SetRange(LOCATION_HAND)
	e2:SetCondition(s.spcon)
	e2:SetOperation(s.spop)
	c:RegisterEffect(e2)

	--to grave
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(13893596,0))
	e3:SetCategory(CATEGORY_TOGRAVE)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e3:SetCode(EVENT_ATTACK_ANNOUNCE)
	e3:SetTarget(s.tgtg)
	e3:SetOperation(s.tgop)
	c:RegisterEffect(e3)

	--atkup
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCode(EFFECT_UPDATE_ATTACK)
	e4:SetValue(s.atkval)
	c:RegisterEffect(e4)

	--cannot destroyed
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e0:SetValue(1)
	c:RegisterEffect(e0)

	--immune
	local e121=Effect.CreateEffect(c)
	e121:SetType(EFFECT_TYPE_SINGLE)
	e121:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e121:SetRange(LOCATION_MZONE)
	e121:SetCode(EFFECT_IMMUNE_EFFECT)
	e121:SetValue(s.efilter)
	c:RegisterEffect(e121)

	--negate
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e5:SetCode(EVENT_ATTACK_ANNOUNCE)
	e5:SetOperation(s.negop1)
	c:RegisterEffect(e5)
	local e6=Effect.CreateEffect(c)
	e6:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e6:SetCode(EVENT_BE_BATTLE_TARGET)
	e6:SetOperation(s.negop2)
	c:RegisterEffect(e6)
	if not s.global_check then
		s.global_check=true
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_TO_GRAVE)
		ge1:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
		ge1:SetOperation(s.choperation)
		Duel.RegisterEffect(ge1,0)
	end
end
s.listed_series={SET_FORBIDDEN_ONE}
s.listed_names={511000244}

function s.cfilter(c)
	return not c:IsAbleToDeckOrExtraAsCost()
end
function s.spcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	local g=Duel.GetMatchingGroup(Card.IsType,tp,LOCATION_GRAVE,0,nil,TYPE_MONSTER)
	return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and g:GetCount()>0
		and not g:IsExists(s.cfilter,1,nil)
end
function s.spop(e,tp,eg,ep,ev,re,r,rp,c)
	local g=Duel.GetMatchingGroup(Card.IsType,tp,LOCATION_GRAVE,0,nil,TYPE_MONSTER)
	Duel.SendtoDeck(g,nil,2,REASON_COST)
end

function s.tgtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_DECK)
end
function s.tgfilter(c)
	return c:IsSetCard(0x40) and c:IsAbleToGrave() and c:IsType(TYPE_MONSTER)
end
function s.tgop(e,tp,eg,ep,ev,re,r,rp)
	local WIN_REASON_EXODIUS = 0x14
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local c=e:GetHandler()
	local g=Duel.SelectMatchingCard(tp,s.tgfilter,tp,LOCATION_HAND+LOCATION_DECK,0,1,1,nil)
	local tc=g:GetFirst()
	if tc then Duel.SendtoGrave(tc,REASON_EFFECT) end
end

function s.choperation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetOwner()
	if not re or not (re:GetHandler():IsCode(13893596) or re:GetHandler():IsCode(511000244)) then return end
	for tc in aux.Next(eg) do
        local code=tc:GetCode()
        local stringid=0
        if code==33396948 then stringid=0
        elseif code==7902349 then stringid=1
        elseif code==70903634 then stringid=2
        elseif code==44519536 then stringid=3
        elseif code==8124921 then stringid=4 
		else return end 
        local e0=Effect.CreateEffect(c)
        e0:SetDescription(aux.Stringid(id,stringid))
		e0:SetProperty(EFFECT_FLAG_CLIENT_HINT)
		e0:SetType(EFFECT_TYPE_SINGLE)
		e0:SetCode(id)
		e0:SetLabel(code)
		e0:SetCondition(s.chopcon)
		c:RegisterEffect(e0,true)
    end
    local ae={c:IsHasEffect(id)}
    local cc={}
    for _,te in ipairs(ae) do
        local code=te:GetLabel()
        local chk=false
        for _,c1 in ipairs(cc) do
            if c1==code then 
                chk=true
                break
            end
        end
        if not chk then table.insert(cc,code) end
    end
	if #cc>=5 and c:IsLocation(LOCATION_MZONE) then
		Duel.Win(tp,WIN_REASON_EXODIUS)
	end
end
function s.chopcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return Duel.IsExistingMatchingCard(Card.IsCode,c:GetControler(),LOCATION_GRAVE,0,1,nil,e:GetLabel())
end

function s.exfilter(c)
	return c:IsSetCard(0x40) and c:IsType(TYPE_MONSTER)
end
function s.atkval(e,c)
	return Duel.GetMatchingGroupCount(s.exfilter,c:GetControler(),LOCATION_GRAVE,0,nil)*1000
end

function s.efilter(e,te)
	return te:GetOwnerPlayer()~=e:GetHandlerPlayer()
end

function s.negop1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local d=Duel.GetAttackTarget()
	if d~=nil then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_DISABLE)
		e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_BATTLE)
		d:RegisterEffect(e1)
		local e2=Effect.CreateEffect(e:GetHandler())
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_DISABLE_EFFECT)
		e2:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_BATTLE)
		d:RegisterEffect(e2)
	end
end
function s.negop2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local a=Duel.GetAttacker()
	if a~=nil then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_DISABLE)
		e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_BATTLE)
		a:RegisterEffect(e1)
		local e2=Effect.CreateEffect(e:GetHandler())
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_DISABLE_EFFECT)
		e2:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_BATTLE)
		a:RegisterEffect(e2)
	end
end
