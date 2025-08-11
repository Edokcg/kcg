--奥利哈刚 赫耳墨斯(ZCG)
function c77239238.initial_effect(c)
    --
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DAMAGE)
	e1:SetType(EFFECT_TYPE_IGNITION)
    e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)	
    e1:SetCountLimit(1) 
	e1:SetRange(LOCATION_MZONE)
	e1:SetCost(c77239238.cost)
	e1:SetTarget(c77239238.target)
	e1:SetOperation(c77239238.operation)
	c:RegisterEffect(e1)	
end
--------------------------------------------------------------
function c77239238.cost(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.CheckLPCost(tp,100) end
    local lp=Duel.GetLP(tp)
    local t={}
    local f=math.floor((lp)/100)
    local l=1
    while l<=f do
        t[l]=l*100
        l=l+1
    end
    Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(77239238,0))
    local announce=Duel.AnnounceNumber(tp,table.unpack(t))
    Duel.PayLPCost(tp,announce)
    e:SetLabel(announce)
    e:GetHandler():SetHint(CHINT_NUMBER,announce)
end
function c77239238.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetTargetPlayer(1-tp)
	Duel.SetTargetParam(e:GetLabel())
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,e:GetLabel())
end
function c77239238.operation(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Damage(p,d,REASON_EFFECT)
end
